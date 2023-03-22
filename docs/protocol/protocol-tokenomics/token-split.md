---
sidebar_position: 2
---

# Token Split

To incentivize the repeaters to add the transaction in the expiry range, we offer an upfront fee and a reward on successfully adding the transaction.

When a token is minted, the value of the token is split into 2 portions: `Mint Reward` and `Burn Reward`.

These portions sum up to the value of the token supplied by an oracle. When a repeater mints a token, they can sell it in the open market for the oracle value but must pay back the `Burn Reward` to the protocol for later use. Failing to pay back the `Burn Reward` will result in a transaction revert.

## Mint Reward

This portion of the token value is retained by the repeater when he mints a token. This portion can be viewed as what the repeater is _borrowing_ from the protocol. The repeater repays the network for this reward by adding the transaction during the expiry range.

## Burn Reward

This portion of the token value is kept safe in the protocol contracts. It is sent back to the repeater once the floating blockspace tokens are burnt. This portion is reserved to incentivize the repeater to add the transaction on expiry range. 
