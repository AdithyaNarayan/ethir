---
sidebar_position: 2
---

# Repeaters 

Repeaters are the nodes in this network whose responsibility is to _"repeat"_ the transactions on expiry of the futures contract and get them mined.

![Repeater flow](/img/repeater_flow.png)

Since this is a decentralised network of repeaters, joining the network as a repeater is open to anyone. Repeaters mint and sell blockspace in the form of futures tokens.

They can then sell this token in the open market. On the expiry of said token, the repeaters repeat the transaction and get it added to the chain by paying the current gas price to the miners. Hence, repeaters are exposing themselves to the risk of gas price fluctuations but they are rewarded as they can mint and sell the tokens. If the price of gas has increased since the sale, they will bear the difference but if the gas price has reduced, they make a profit even apart from the time-value of the initial deposit.

There is also an economic incentive, detailed in [Burn Reward](../protocol-tokenomics/burn-reward.md), to ensure that the repeaters repeat the transaction.

Since anyone can run a repeater, there is no single implementation that each repeater should follow. There is a reference implementation detailed in the [Developer documentation](../../dev/repeaters/reference-impl), but not all repeaters need to conform to that implementation. However, all repeaters must ensure they follow the [Repeater Rule Set](../../dev/repeaters/rule-set) so that they do not get penalised.
