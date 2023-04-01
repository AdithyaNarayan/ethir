use ethers::prelude::*;

const RPC_URL: &str = "https://eth.llamarpc.com";

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let provider = Provider::<Http>::try_from(RPC_URL)?;

    let current_block_number = provider.get_block_number().await?.as_u64();

    for block_number in (current_block_number - 200)..current_block_number {
        let block = provider.get_block(block_number).await?.unwrap();

        println!(
            "Percent Gas used: {:?}\nBase Fee: {:?}",
            block.gas_used * 100 / block.gas_limit,
            block.base_fee_per_gas.unwrap()
        );
    }

    Ok(())
}

