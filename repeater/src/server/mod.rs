use std::convert::TryFrom;
use std::sync::{Arc, RwLock};
use std::time::SystemTime;

use ethers::types::{Bytes, NameOrAddress, TransactionRequest};
use tonic::{Request, Response, Status};

use crate::api::spaceblock_service_server::SpaceblockService;
use crate::api::{AddTransactionRequest, AddTransactionResponse};
use crate::state::State;
use crate::txn::PendingTransaction;

#[derive(Default)]
pub struct SpaceblockServiceImpl {
    state: Arc<RwLock<State>>,
}

impl SpaceblockServiceImpl {
    pub fn new(state: Arc<RwLock<State>>) -> Self {
        Self { state }
    }
}

#[tonic::async_trait]
impl SpaceblockService for SpaceblockServiceImpl {
    async fn add_transaction(
        &self,
        request: Request<AddTransactionRequest>,
    ) -> Result<Response<AddTransactionResponse>, Status> {
        let request = request.get_ref();

        let txn = TransactionRequest::new()
            .data(request.data.parse::<Bytes>().unwrap())
            .to(NameOrAddress::Address(request.to_address.parse().unwrap()));
        {
            let mut writable_state = self.state.write().unwrap();
            writable_state.txn_pool.push(PendingTransaction::new(
                txn,
                request.from_address.parse().unwrap(),
                SystemTime::try_from(request.time.clone().expect("Populate time field")).unwrap(),
            ));
        }

        Ok(Response::new(AddTransactionResponse {}))
    }
}
