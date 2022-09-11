use std::collections::BinaryHeap;

use crate::txn::PendingTransaction;

#[derive(Clone, Debug, Default)]
pub struct State {
    pub txn_pool: BinaryHeap<PendingTransaction>,
}

impl State {
    pub fn new() -> Self {
        Self {
            ..Default::default()
        }
    }
}
