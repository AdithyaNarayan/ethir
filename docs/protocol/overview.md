---

sidebar_position: 1
---

# Overview 

This page serves as a quick introduction to **Ethir**, a blockspace futures market, for the future.

## What is a blockspace futures market? 

Blockchains, apart from being decentralised state machines, can also be viewed as a market for blockspace, where the miners are the sellers and the users are in an auction to secure blockspace. Users bid, through transaction fees, to make sure that their transaction is added to the block. Currently, this auction is held only for immediate consumption of blockspace. This project details a futures market, where blockspace can be sold off days or even months before consumption.

Ethir addresses the questions of how such a network can be designed in a decentralised manner, who are the players in this network, and how they interact with each other to (nearly) guarantee that a transaction will be mined in the future.
Users in this network buy expiring futures tokens which gives them the right to add a transaction on the expiry of said token. This design creates a predictive market for future gas prices and also allows them to trade blockspace as if it were a commodity.

### Use cases 

1. **Cron Scheduler**: If we view a blockchain as a decentralised state machine, one missing feature is that of cron jobs. Cron jobs are tasks that run repeatedly in equal intervals. With this blockspace futures market, a user can schedule a smart contract call or any arbitrary code to run on-chain in equal intervals. This means that smart contracts can now be reactive and even self-invoking!
1.  **Gas Price Discovery**: The future tokens, since they represent a unit of blockspace (covered in TODO), are now reliable indicators of the gas price on that particular time slot and will eventually converge to the actual gas price at the time of expiry. This allows for price discovery and users can add a transaction when it is cheapest for them to do so.
1.  **NFT mints and other seasonal spikes**: NFT mints sometimes occupy a large portion of the blockspace and drive up the gas prices. A huge NFT drop can now reserve blockspace for a cheaper price beforehand. 

## How do I take part as a user? 

TODO
