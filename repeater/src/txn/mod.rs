use std::{cmp::Ordering, time::SystemTime};

use ethers::types::{TransactionRequest, H160};

#[derive(Clone, Debug, Eq, PartialEq)]
pub struct PendingTransaction {
    pub transaction_data: TransactionRequest,
    pub original_sender: H160,
    pub timeslot: SystemTime,
}

impl PendingTransaction {
    pub fn new(
        transaction_data: TransactionRequest,
        original_sender: H160,
        timeslot: SystemTime,
    ) -> Self {
        Self {
            transaction_data,
            original_sender,
            timeslot,
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
