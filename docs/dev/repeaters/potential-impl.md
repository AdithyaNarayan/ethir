---
sidebar_position: 3
---

# Other Potential Implementations

## Best Fit Repeater 

The best fit algorithm finds the right time within the time slot to add the transaction so as to minimise the gas fees they spend. Finding of the time slot itself can be done by using the oracle to extrapolate the value of gas in the range.

## Miner Run Repeater

Another notable implemetation would be a repeater that is run by a miner or validator of the network. Since they are a miner, they can add their transactions to the chain even with a low (read 0) gas fee. Hence, this repeater has a backdoor and can send transactions with 0 gas fee that are added to the chain. This means that miners themselves have a very good incentive to run repeaters themselves as they don't pay the current gas fees.
