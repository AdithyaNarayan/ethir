---
sidebar_position: 1
---

# Interface Rule Set

These are the following rules that all repeater implementations must follow. Somewhat similar to an `exeuction_specs`/Yellow Paper for the Repeater.

1. Set aside a pre-determined amount as collateral to join the network and gain the ability to mint futures tokens.
2. Expose a `ethir_scheduleTransaction` grpc endpoint to allow users to submit transactions.
3. At the time of expiry of tokens, send an atomic transaction bundle with `{ user_transaction, burn_futures }`, where the transaction burns an equivalent amount of futures token as the gas used.
