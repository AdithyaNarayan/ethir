// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../interfaces/IEthirOracle.sol";
import "../interfaces/IUniswapQuoter.sol";
import {LibTokenAddressGenerator} from "../library/LibTokenAddressGenerator.sol";

contract EthirOracle is IEthirOracle {
    address immutable factory;
    IUniswapQuoter immutable quoter;

    address constant WETH9_ADDRESS =
        address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);

    constructor(address _factory, address _quoter) {
        factory = _factory;
        quoter = IUniswapQuoter(_quoter);
    }

    function getValueInETH(uint256 expiryBlockNumber)
        external
        view
        returns (uint256)
    {
        address token = LibTokenAddressGenerator.getTokenFor(
            expiryBlockNumber,
            factory
        );

        IUniswapQuoter.QuoteExactInputSingleParams
            memory params = IUniswapQuoter.QuoteExactInputSingleParams({
                tokenIn: token,
                tokenOut: WETH9_ADDRESS,
                amountIn: 10**9,
                fee: 3000,
                sqrtPriceLimitX96: 0 // price limit can be safely ignored while getting quote
            });

        (uint256 price, , , ) = quoter.quoteExactInputSingle(params);

        return price;
    }
}
