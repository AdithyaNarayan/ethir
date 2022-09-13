use ethers::{
    contract::abigen,
    prelude::{k256::ecdsa::SigningKey, SignerMiddleware},
    providers::{Provider, Ws},
    signers::{Signer, Wallet},
    types::{NameOrAddress, H160},
};
use ethers_flashbots::FlashbotsMiddleware;
use futures::executor::block_on;
use std::{
    future::Future,
    pin::Pin,
    sync::{Arc, RwLock},
    task::{Context, Poll},
    time::{Duration, SystemTime},
};
use tokio::{self, time::sleep};
use url::Url;

use crate::state::State;

abigen!(
    EthirFutureToken,
    r#"[
        function mint(address to, uint256 amount) public
        function burn(address from, address callAddress, bytes memory data) public returns (bytes memory)
    ]"#
);

pub struct Relayer {
    pub state: Arc<RwLock<State>>,

    poll_time: Duration,
    contract: EthirFutureToken<
        SignerMiddleware<FlashbotsMiddleware<Provider<Ws>, Wallet<SigningKey>>, Wallet<SigningKey>>,
    >,
}

impl Relayer {
    pub fn new(poll_time: Duration, provider: Provider<Ws>, state: Arc<RwLock<State>>) -> Self {
        let signer_keys = dotenv::var("BUNDLE_SIGNER_KEYS").expect("Add signer keys to .env");
        let signer = signer_keys
            .parse::<Wallet<SigningKey>>()
            .expect("Invalid private keys");

        let client = SignerMiddleware::new(
            FlashbotsMiddleware::new(
                provider,
                Url::parse("https://relay-goerli.flashbots.net").unwrap(),
                signer.clone().with_chain_id(5u64),
            ),
            signer.clone().with_chain_id(5u64),
        );
        let client = Arc::new(client);

        // TODO: Replace with CREATE2
        let future_contract_address: H160 = dotenv::var("CONTRACT_ADDRESS")
            .expect("Enter future contract address")
            .parse()
            .unwrap();
        let contract = EthirFutureToken::new(future_contract_address, client.clone());

        Self {
            poll_time,
            state,
            contract,
        }
    }

    async fn run(&self) {
        let mut transactions = Vec::new();

        // Pop all transactions that are ready
        {
            let mut state = self.state.write().unwrap();

            let current_time = SystemTime::now();

            while state
                .txn_pool
                .peek()
                .map(|txn| txn.timeslot <= current_time)
                .unwrap_or(false)
            {
                transactions.push(state.txn_pool.pop().unwrap());
            }
        }

        for transaction in transactions {
            match transaction.transaction_data.to.unwrap() {
                NameOrAddress::Address(address) => {
                    // TODO: Searcher sponsored transaction
                    let txn = self
                        .contract
                        .burn(
                            transaction.original_sender,
                            address,
                            transaction.transaction_data.data.unwrap(),
                        )
                        .send()
                        .await
                        .unwrap()
                        .await
                        .unwrap()
                        .unwrap();

                    println!("Added {}", txn.transaction_hash);
                }
                _ => {}
            }
        }
    }
}

impl Future for Relayer {
    type Output = ();

    fn poll(self: Pin<&mut Self>, cx: &mut Context<'_>) -> Poll<Self::Output> {
        block_on(self.run());

        let waker = cx.waker().clone();
        let sleep_duration = self.poll_time.clone();
        tokio::spawn(async move {
            sleep(sleep_duration).await;
            waker.wake();
        });

        Poll::Pending
    }
}
