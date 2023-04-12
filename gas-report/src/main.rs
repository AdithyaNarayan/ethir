use ethers::prelude::*;
use plotters::prelude::*;

const RPC_URL: &str = "https://eth.llamarpc.com";

const EXPIRY_BLOCK_RANGE: usize = 200;

struct BlockData {
    pub block_number: u64,
    pub gas_used: u128,
    pub gas_limit: u128,
    pub base_fee_per_gas: u128,
}

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let provider = Provider::<Http>::try_from(RPC_URL)?;

    let current_block_number = provider.get_block_number().await?.as_u64();

    let mut data = Vec::with_capacity(EXPIRY_BLOCK_RANGE);

    for block_number in (current_block_number - (EXPIRY_BLOCK_RANGE as u64))..current_block_number {
        let block = provider.get_block(block_number).await?.unwrap();

        println!("{}", block_number);
        // println!(
        //     "Percent Gas used: {:?}\nBase Fee: {:?}",
        //     block.gas_used * 100 / block.gas_limit,
        //     block.base_fee_per_gas.unwrap()
        // );

        data.push(BlockData {
            block_number,
            gas_used: block.gas_used.as_u128(),
            gas_limit: block.gas_limit.as_u128(),
            base_fee_per_gas: block.base_fee_per_gas.unwrap().as_u128(),
        });
    }

    draw_plot(data);

    Ok(())
}

fn draw_plot(data: Vec<BlockData>) {
    let root_area = BitMapBackend::new("chart.png", (600, 400)).into_drawing_area();
    root_area.fill(&WHITE).unwrap();

    let mut chart_ctx = ChartBuilder::on(&root_area)
        .set_label_area_size(LabelAreaPosition::Left, 40.0)
        .set_label_area_size(LabelAreaPosition::Bottom, 40.0)
        .set_label_area_size(LabelAreaPosition::Right, 40.0)
        .set_label_area_size(LabelAreaPosition::Top, 40.0)
        .caption("Gas Usage", ("inter", 40.0))
        .build_cartesian_2d(
            data[0].block_number - 1..data[EXPIRY_BLOCK_RANGE - 1].block_number + 1,
            0.0..70.0,
        )
        .unwrap();

    chart_ctx.configure_mesh().draw().unwrap();

    // chart_ctx
    //     .draw_series(LineSeries::new(
    //         data.iter().map(|block| {
    //             (
    //                 block.block_number,
    //                 (block.gas_used * 100 / block.gas_limit) as i32,
    //             )
    //         }),
    //         &BLUE,
    //     ))
    //     .unwrap();
    //
    let mut accumulator = 0;
    chart_ctx
        .draw_series(
            AreaSeries::new(
                data.iter().map(|block| {
                    accumulator += block.base_fee_per_gas * block.gas_used;
                    (
                        block.block_number,
                        accumulator as f64 / ((10 as u128).pow(18) as f64),
                    )
                }),
                0.0,
                &RED.mix(0.2),
            )
            .border_style(&RED),
        )
        .unwrap();
}
