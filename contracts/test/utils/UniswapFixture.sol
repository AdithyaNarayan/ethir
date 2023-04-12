// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
pragma abicoder v2;

import "forge-std/Test.sol";

import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Factory.sol";
import "@uniswap/v3-core/contracts/interfaces/IERC20Minimal.sol";
import "@uniswap/v3-periphery/contracts/SwapRouter.sol";
import "@uniswap/v3-periphery/contracts/NonfungibleTokenPositionDescriptor.sol";
import "@uniswap/v3-periphery/contracts/NonfungiblePositionManager.sol";
import "solmate/tokens/ERC20.sol";

string constant v3FactoryArtifact = "test/utils/UniswapV3Factory.json";
string constant weth9Artifact = "test/utils/WETH9.json";

interface WETH9 is IERC20Minimal {
    function deposit() external payable;
}

// Base fixture deploying V3 Factory, V3 Router and WETH9
contract UniswapFixture is Test {
    IUniswapV3Factory public factory;
    WETH9 public weth9;
    SwapRouter public router;

    // Deploys WETH9 and V3 Core's Factory contract, and then
    // hooks them on the router
    function setUp() public virtual {
        address _weth9 = deployCode(weth9Artifact);
        weth9 = WETH9(_weth9);

        address _factory = deployCode(v3FactoryArtifact);
        factory = IUniswapV3Factory(_factory);

        router = new SwapRouter(_factory, _weth9);
    }
}
