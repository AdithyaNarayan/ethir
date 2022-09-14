# ethir - a blockspace futures market

ethir is a blockspace futures market where users can buy expiring futures which gives them the right to add a transaction on expiry of said token. This allows users to bet on future gas prices and also allows them to buy/sell blockspace as if it were a commodity.

Note: This project is still in development.

## Use cases
- Predictive market for future gas prices
- Scheduling cron jobs and repetitive tasks
- Reserve blockspace for big events like NFT minting

## How to use
- User buys `ETHIR15102022` tokens on the open market through their favourite dex
- Each token represents 1 gas unit of blockspace for that particular day
- User submits a transaction bundle to the relayer bot on or before the expiry date
- Relayer submits the transaction using flashbot auctions (searcher sponsored transaction) and adds it the block. The transaction bundle sent to flashbot also includes a transaction to burn the tokens based on the gas used in the transaction

## How it works
```
+--------+    buy on dex    +----------------+
|  User  | <--------------  |  Future token  |
+--------+                  +----------------+
    |                        ^
    | send                  /
    | transaction     burn /
    |                     /
    v                    /
+-----------------------+      Flashbots     +----------+
|  Relayer bot network  |  --------------->  |  Miners  |
+-----------------------+                    +----------+

```

## How to run

Run the relayer bot that polls every one minute from the transaction pool and sends it to flashbots.
```sh
cargo run
```

It opens a grpc server at port 9000, and you can add a transaction using the following command by replacing the necessary data.

```sh
grpcurl -plaintext -d '{ "id": "1", "from_address": "<from_address>", "to_address": "<to_address>", "data": "<call_data>", "time":"2022-09-10T00:30:00.999999999Z" }' localhost:9000 api.SpaceblockService.AddTransaction
```

Note: Make sure to fill the env variables with the deployed future contract

## Planned upgrades
- Incentivize relayer bots to definitely add the transaction after minting the future tokens using slashing so that they do not default on delivering the transaction
- Bot network instead of single relayer. Relayers can then have additional logic (for example, cheapest time to send the transactions in the day), so that they can profit more
- Replace the fixed contract address with `CREATE2` contract address
- Create a liquidity pool for each expiring future
- Add unit and integration tests
