use std::{
    process::exit,
    sync::{Arc, RwLock},
    time::{Duration, SystemTime},
};

mod relayer;
mod state;
mod txn;
mod utils;
mod api {
    include!("api/api.rs");

    pub(crate) const FILE_DESCRIPTOR_SET: &[u8] =
        tonic::include_file_descriptor_set!("spaceblock_descriptor");
}
mod server;

use anyhow::Result;
use dotenv;
use ethers::providers::{Middleware, Provider, StreamExt, Ws};
use futures::future;
use relayer::Relayer;
use state::State;
use tonic::transport::Server;

use api::spaceblock_service_server::SpaceblockServiceServer;
use server::SpaceblockServiceImpl;
use txn::PendingTransaction;

#[tokio::main]
async fn main() -> Result<()> {
    ctrlc::set_handler(move || {
        println!("Received Ctrl-C. Stopping...");
        exit(0);
    })?;
    dotenv::dotenv()?;

    let state = Arc::new(RwLock::new(State::new()));

    {
        let mut temp = PendingTransaction::new();

        temp.timeslot = SystemTime::now().checked_add(Duration::from_secs(30)).unwrap();

        state.write().unwrap().txn_pool.push(temp);
    }

    let relayer = Relayer::new(Duration::from_secs(10), state.clone());

    let addr = "[::1]:9000".parse().unwrap();
    let service = SpaceblockServiceImpl::new(state.clone());

    println!("SpaceblockService server listening on {}", addr);

    let reflection_service = tonic_reflection::server::Builder::configure()
        .register_encoded_file_descriptor_set(api::FILE_DESCRIPTOR_SET)
        .build()
        .unwrap();

    let server = Server::builder()
        .add_service(SpaceblockServiceServer::new(service))
        .add_service(reflection_service)
        .serve(addr);

    future::select(relayer, Box::pin(server)).await;

    let url = dotenv::var("ETH_WS_URL")?;
    let provider = Provider::<Ws>::connect(url).await?;

    let mut stream = provider.watch_blocks().await?;
    while let Some(block) = stream.next().await {
        println!("{}", block);
        let block = provider.get_block(block).await?.unwrap();
        println!("{}", block.number.unwrap());
    }

    Ok(())
}
