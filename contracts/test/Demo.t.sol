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

        vm.deal(address(this), 100 ether);
    }

    function repeaterPayBack(uint256 expiryBlockNumber, uint256 mintAmount)
        public
    {
        uint256 amountToSend = (71 *
            ethirOracle.getValueInWei(expiryBlockNumber) *
            mintAmount) / 100;

        address token = LibTokenAddressGenerator.getTokenFor(
            expiryBlockNumber,
            address(ethirFactory)
        );

        address payable payableToken = payable(token);

        payableToken.transfer(amountToSend);
    }

    function testUniswapV3FactoryDeployment() external {
        assertEq(
            address(factory),
            address(EthirOracle(ethirOracle).UNISWAP_V3_FACTORY())
        );

        address token = ethirFactory.deploy(block.number + 200);

        assertEq(factory.getPool(token, address(weth9), 3000), address(0x0));
    }

    function testOraclePricing() external {
        ethirFactory.deploy(10_000);
        assertEq(ethirOracle.getValueInWei(10_000), 30 gwei);
    }

    function arbitraryInternalTransaction() external view {
        for (uint256 i = 0; i < 10; ++i) {
            assembly {
                mstore(0x0, 0x1)
                pop(mload(0x0))
            }
        }
    }

    function testMintAndDeal() external {
        ethirCollateralManager.depositCollateral{value: 1 ether}();

        uint256 expiryBlockNumber = block.number + 10_000;
        uint256 amount = 10_000;

        address token = ethirFactory.deploy(expiryBlockNumber);
        EthirTokenImpl(token).mint(
            address(this),
            amount,
            address(this),
            abi.encodeWithSelector(
                this.repeaterPayBack.selector,
                expiryBlockNumber,
                amount
            )
        );
        vm.roll(300);

        EthirTokenImpl(token).burn(
            address(this),
            address(this),
            abi.encodeWithSelector(this.arbitraryInternalTransaction.selector)
        );
    }

    receive() external payable {}
}
