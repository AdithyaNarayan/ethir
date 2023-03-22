---
sidebar_position: 1
---

# Collateral 

The first step to secure the value of the network is the collateral laid out by the network. The collateral in this protocol serves the same purpose as it does in most lending protocols such as Aave/Compound/Euler.

Repeaters must put aside some amount of tokens as collateral in order to be able to mint the blockspace futures token.

## Collateral Value Invariant

Similar to lending protocols, each repeater has a health factor, where the `Health Factor` is defined as `Value of Collateral / Value of Floating Blockspace Futures Mint Rewards`.

The definition of `Floating Blockspace Futures Tokens` is in the [next section](./token-split.md).

A repeater can only mint new tokens if their health factor after minting is greater than 1.

:::danger Note 

Unlike lending protocols, the health factor of a repeater can be less than 1 as long as the minted blockspace futures have not expired.

:::

## Liquidation Scenario

When a token expires and the repeater fails to add transaction on chain, the liquidators will liquidate a portion of the collateral set aside for such a scenario. This amount can be sent to the holder of the token as compensation for a default. Refer to the [Risk section](../risk) for more information.  
