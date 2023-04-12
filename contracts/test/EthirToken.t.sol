// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/core/token/EthirToken.sol";
import "../src/core/token/EthirTokenImpl.sol";
import "../src/core/EthirCollateralManager.sol";
import "../src/core/EthirOracle.sol";
import "../src/interfaces/IEthirTokenFactory.sol";

import {LibString} from "solady/utils/LibString.sol";

interface IERC20 {
    function name() external returns (string memory);

    function symbol() external returns (string memory);
}

contract EthirTokenTest is Test, IEthirTokenFactory {
    address ethirTokenImpl;
    address collateralManager;
    address oracle;

    function setUp() external {
        ethirTokenImpl = address(new EthirTokenImpl());

        oracle = address(new EthirOracle(address(this)));

        collateralManager = address(new EthirCollateralManager(oracle));
    }

    function getParameters()
        external
        view
        returns (
            bytes32,
            address,
            address,
            address,
            uint256
        )
    {
        string memory blockNumberString = LibString.toString(block.number);

        bytes32 blockNumberBytes;
        assembly {
            blockNumberBytes := mload(add(blockNumberString, 0x20))
        }

        return (
            blockNumberBytes,
            ethirTokenImpl,
            collateralManager,
            oracle,
            block.number
        );
    }

    function testSymbol() external {
        IERC20 token = IERC20(address(new EthirToken()));

        assertEq(token.symbol(), "GAS-1");
        assertEq(token.name(), "Ethir Gas 1");

        vm.roll(9999);

        token = IERC20(address(new EthirToken()));

        assertEq(token.symbol(), "GAS-9999");
        assertEq(token.name(), "Ethir Gas 9999");
    }
}
