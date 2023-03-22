---
sidebar_position: 1
---

# User Flow 

Users of the protocol would like to purchase futures token of the blockspace. The protocol and the repeaters are responsible for minting this futures token. Each futures token has an expiry date, upon which the token can be exercised for the underlying blockspace.

TODO: update pic
![User flow](/img/user_flow.png)

## Trader User Flow

1. Purchase `ETHIR-<BLOCK_RANGE_START>` from your favourite dex.
  1. A new token exists for each 200 block blockrange. For example, `ETHIR-7800` means that the expiry range of said token is block number 7800 to 8000.
1. This token can be traded on any exchange and represents on aggregate, the cost of 1 gas unit of blockspace in the expiry range.

These tokens need not be exercised. After expiry, these tokens can be burned for their burn rewards. These burn rewards will naturally be worth less than if the token was exercised.

## Procuring underlying blockspace

1. Once a user has obtained a `ETHIR-<BLOCK_RANGE_START>`, they can submit transactions to the repeater for exercising the transaction.
1. This transaction is submitted to the repeater network or a repeater of your choice. This repeater will submit the transaction during the expiry range and burn a proportionate amount of your future tokens. This way, your trasaction has been added to the chain during the expiry range of your token without needing to pay additional gas fees.
