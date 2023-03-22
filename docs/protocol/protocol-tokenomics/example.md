---
sidebar_position: 3
---

# Example Scenarios

## Gas Price increases

1. Repeater Ravi puts up 1 ETH as collateral and joins the network as a repeater.
1. He then mints 1000 `ETHIR-7800` each costing 0.001 ETH.
1. The total `Mint Rewards` is 0.7 ETH and the `Burn Rewards` are 0.3 ETH. (Here, alpha is taken as 70%)
1. He sells the 1000 tokens at Uniswap for a total of 1 ETH.
1. He returns 0.3 ETH to the protocol and takes 0.7 ETH for himself to spend.
1. Ravi's health factor is now 1.428.
1. When block 7800 arrives, the gas price of 1 gas unit is now 0.0015 ETH.
1. The 1000 tokens now represent 1.3 ETH of gas fees.
1. His health factor is now less than 1.
1. He can either default or add the transaction.

### Ravi defaults

1. If Ravi defaults, he does not spend any ETH on gas to add the transaction but he loses 1 ETH from his collateral and 0.3 ETH from his `Burn Rewards` vault.

Net: -1.3ETH + 0.7 ETH = -0.6 ETH

### Ravi adds the transaction

1. Ravi spends 1.3ETH to add a transaction that costs 1000 gas. He retreives his 0.3 ETH reward and is able to safely take out his collateral.

Net: -1.3ETH + 0.7 ETH = -0.6 ETH

It is evident that even for small loses, Ravi profits due to the fact that his collateral is refundable and he behaves as the network expected him. Also, he earned the 0.7 ETH before which has a time premium! He could have invested this ETH and made profits greater than 0.5ETH in the time the block was expired. The threshold amount for Ravi to default is therefore, the collateral + `Burn Rewards`.

## Gas Price decreases

1. Repeater Ravi puts up 1 ETH as collateral and joins the network as a repeater.
1. He then mints 1000 `ETHIR-7800` each costing 0.001 ETH.
1. The total `Mint Rewards` is 0.7 ETH and the `Burn Rewards` are 0.3 ETH. (Here, alpha is taken as 70%)
1. He sells the 1000 tokens at Uniswap for a total of 1 ETH.
1. He returns 0.3 ETH to the protocol and takes 0.7 ETH for himself to spend.
1. Ravi's health factor is now 1.428.
1. When block 7800 arrives, the gas price of 1 gas unit is now 0.0009 ETH.
1. The 1000 tokens now represent 0.9 ETH of gas fees.
1. His health factor is now more than 1.5.
1. He can either default or add the transaction.

### Ravi defaults

1. If Ravi defaults, he does not spend any ETH on gas to add the transaction but he loses 1 ETH from his collateral and 0.3 ETH from his `Burn Rewards` vault.

Net: -1.3ETH + 0.7 ETH = -0.6 ETH

### Ravi adds the transaction

1. Ravi spends 0.9ETH to add a transaction that costs 1000 gas. He retreives his 0.3 ETH reward and is able to safely take out his collateral.

Net: -0.9ETH + 0.3 ETH + 0.7 ETH = 0.1 ETH

In this case, it is natural for Ravi to add the transaction as well.

## Black Swan Event

Alpha value is such that is is natural for default

TODO
