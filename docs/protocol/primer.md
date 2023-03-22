---
sidebar_position: 2
---

# Primer 

This page brings into context the information required to fully understand the inner architecture and working of the protocol. 

## Gas unit

A gas unit is the smallest unit of measurement of computation on the ethereum blockchain. Each opcode in the EVM is associated with a certain amount of gas that it costs to carry said operation. This is done so as to prevent overloading of computational power on the validator node. It prevents attacks such as a denial of service attack, where malicious users try to bring down the network by spamming a large amount of computationally intensive transactions. However, they will need to pay fees proportional to the gas used and this becomes a very increasingly expensive attack to carry out.

## Ethereum Transaction Marketplace

Pending transactions are picked from the mempool/txnpool by validators. Validators order transactions that align to their incentives, usually by the gas fee of the transaction. 
Since all transactions are sequential and ordered within the same block, transactions with higher gas fees lands in the top part of the block and lower fees lands in the bottom and ones that are even lower do no land in the block and will have to wait longer for succeeding blocks.

## Gas as a unit of blockspace

Ethereum blockspace[^1] is naturally constrained by the amount of computation that the validator can carry out and validate within the ~12 seconds between each block. Hence, it is a trivially viable thought that gas is the fundamental unit of blockspace in the Ethereum blockchain.


[^1]: [Block size](https://ethereum.org/en/developers/docs/blocks/#block-size) in Ethereum Developer Docs and Yellow paper is defined by a certain amount of gas units as the upper limit and target. Currently, it sits at a limit of 30 million gas units per block.

