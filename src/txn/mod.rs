use std::{cmp::Ordering, time::SystemTime};

use ethers::types::H160;

#[derive(Clone, Debug, Eq, PartialEq)]
pub struct PendingTransaction {
    pub signed_txn_hash: String,
    pub signed_txn_payload: String,

    pub original_sender: H160,

    pub timeslot: SystemTime,
}

impl PendingTransaction {
    pub fn new() -> Self {
        Self {
            signed_txn_hash: String::new(),
            signed_txn_payload: String::new(),

            original_sender: H160::zero(),
            timeslot: SystemTime::UNIX_EPOCH,
        }
    }
}

impl Ord for PendingTransaction {
    fn cmp(&self, other: &Self) -> Ordering {
        // Reverse to get min heap
        other.timeslot.cmp(&self.timeslot)
    }
}

impl PartialOrd for PendingTransaction {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}
