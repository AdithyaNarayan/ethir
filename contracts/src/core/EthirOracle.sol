// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../interfaces/IEthirOracle.sol";
import "../interfaces/IUniswapQuoter.sol";
import "../library/LibTokenAddressGenerator.sol";
import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Factory.sol";
import "@uniswap/v3-core/contracts/interfaces/pool/IUniswapV3PoolState.sol";
import "@uniswap/v3-periphery/contracts/libraries/OracleLibrary.sol";

contract EthirOracle is IEthirOracle {
    address public immutable factory;
    IUniswapQuoter immutable quoter;

    address constant WETH9_ADDRESS =
        address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);

    IUniswapV3Factory constant UNISWAP_V3_FACTORY =
        IUniswapV3Factory(0x1F98431c8aD98523631AE4a59f267346ea31F984);

    uint256 constant DEFAULT = 30 gwei;

    constructor(address _factory, address _quoter) {
        factory = _factory;
        quoter = IUniswapQuoter(_quoter);
    }

    function getValueInWei(uint256 expiryBlockNumber)
        public
        view
        returns (uint256 price)
    {
        address token = LibTokenAddressGenerator.getTokenFor(
            expiryBlockNumber,
            factory
        );

        address poolAddress = UNISWAP_V3_FACTORY.getPool(
            token,
            WETH9_ADDRESS,
            3000
        );

        if (poolAddress != address(0x0)) {
            (, int24 currentTick, , , , , ) = IUniswapV3PoolState(poolAddress)
                .slot0();

            return
                OracleLibrary.getQuoteAtTick(
                    currentTick,
                    10**8,
                    token,
                    WETH9_ADDRESS
                );
        }

        uint256 prev = expiryBlockNumber - 200;
        uint256 prev2 = expiryBlockNumber - 400;
        uint256 prev3 = expiryBlockNumber - 600;
        uint256 prev4 = expiryBlockNumber - 800;
        uint256 prev5 = expiryBlockNumber - 1000;

        address tokenPrev = LibTokenAddressGenerator.getTokenFor(prev, factory);
        address tokenPrev2 = LibTokenAddressGenerator.getTokenFor(
            prev2,
            factory
        );
        address tokenPrev3 = LibTokenAddressGenerator.getTokenFor(
            prev3,
            factory
        );
        address tokenPrev4 = LibTokenAddressGenerator.getTokenFor(
            prev4,
            factory
        );
        address tokenPrev5 = LibTokenAddressGenerator.getTokenFor(
            prev5,
            factory
        );

        if (
            tokenPrev == address(0x0) ||
            tokenPrev2 == address(0x0) ||
            tokenPrev3 == address(0x0) ||
            tokenPrev4 == address(0x0) ||
            tokenPrev5 == address(0x0)
        ) {
            return DEFAULT;
        }

        price =
            (getValueInWei(prev) +
                getValueInWei(prev2) +
                getValueInWei(prev3) +
                getValueInWei(prev4) +
                getValueInWei(prev5)) /
            5;
    }
}
