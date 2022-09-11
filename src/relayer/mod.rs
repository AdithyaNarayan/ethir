use std::{
    future::Future,
    pin::Pin,
    sync::{Arc, RwLock},
    task::{Context, Poll},
    time::{Duration, SystemTime},
};
use tokio::{self, time::sleep};

use crate::state::State;

pub struct Relayer {
    pub state: Arc<RwLock<State>>,

    poll_time: Duration,
}

impl Relayer {
    pub fn new(poll_time: Duration, state: Arc<RwLock<State>>) -> Self {
        Self { poll_time, state }
    }

    fn run(&self) {
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

        println!("{:?}", transactions);
    }
}

impl Future for Relayer {
    type Output = ();

    fn poll(self: Pin<&mut Self>, cx: &mut Context<'_>) -> Poll<Self::Output> {
        self.run();

        let waker = cx.waker().clone();
        let sleep_duration = self.poll_time.clone();
        tokio::spawn(async move {
            sleep(sleep_duration).await;
            waker.wake();
        });

        Poll::Pending
    }
}
