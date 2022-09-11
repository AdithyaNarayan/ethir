use futures::future::BoxFuture;
use std::{
    future::Future,
    pin::Pin,
    task::{Context, Poll},
    time::Duration,
};
use tokio::{self, time::sleep};

/// A future that calls a function after every poll time
pub struct Poller {
    pub poll_time: Duration,

    pub function: Box<dyn Fn() -> BoxFuture<'static, ()> + Send + Sync>,
}

impl Future for Poller {
    type Output = ();

    fn poll(self: Pin<&mut Self>, cx: &mut Context<'_>) -> Poll<Self::Output> {
        tokio::spawn((self.function)());

        let waker = cx.waker().clone();
        let sleep_duration = self.poll_time.clone();
        tokio::spawn(async move {
            sleep(sleep_duration).await;
            waker.wake();
        });

        Poll::Pending
    }
}
