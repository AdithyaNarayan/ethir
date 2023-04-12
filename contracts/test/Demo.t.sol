// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/core/token/EthirToken.sol";
import "../src/core/token/EthirTokenImpl.sol";
import "../src/core/EthirCollateralManager.sol";
import "../src/core/EthirOracle.sol";
import "../src/core/EthirTokenFactory.sol";
import "./utils/UniswapFixture.sol";

import {LibString} from "solady/utils/LibString.sol";

contract DemoTest is UniswapFixture {
    EthirTokenImpl ethirTokenImpl;
    EthirCollateralManager ethirCollateralManager;
    EthirOracle ethirOracle;
    EthirTokenFactory ethirFactory;

    function setUp() public override {
        super.setUp();

        ethirTokenImpl = new EthirTokenImpl();
        ethirOracle = new EthirOracle(address(this));
        ethirCollateralManager = new EthirCollateralManager(
            address(ethirOracle)
        );

        ethirFactory = new EthirTokenFactory();
        ethirFactory.setImplementation(address(ethirTokenImpl));
        ethirFactory.setCollateralManager(address(ethirCollateralManager));
        ethirFactory.setOracle(address(ethirOracle));
    }

    function testUniswapV3FactoryDeployment() external {
        assertEq(
            address(factory),
            address(EthirOracle(ethirOracle).UNISWAP_V3_FACTORY())
        );

        address token = ethirFactory.deploy(block.number + 200);

        assertEq(factory.getPool(token, address(weth9), 3000), address(0x0));
    }
}
