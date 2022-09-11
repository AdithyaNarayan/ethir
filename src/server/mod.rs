use std::sync::{Arc, RwLock};

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
        {
            let mut writable_state = self.state.write().unwrap();
            writable_state.txn_pool.push(PendingTransaction::new());
        }
        println!("Request {:?}", request);

        Ok(Response::new(AddTransactionResponse {}))
    }
}
