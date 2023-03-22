// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/EthirToken.sol";
import "../src/EthirTokenImpl.sol";
import "../src/interfaces/IEthirTokenFactory.sol";

import {LibString} from "solady/utils/LibString.sol";

interface IERC20 {
    function name() external returns (string memory);

    function symbol() external returns (string memory);
}

contract EthirTokenTest is Test, IEthirTokenFactory {
    address ethirTokenImpl;

    function setUp() external {
        ethirTokenImpl = address(new EthirTokenImpl());
    }

    function getParameters() external view returns (bytes32, address) {
        string memory blockNumberString = LibString.toString(block.number);

        bytes32 blockNumberBytes;
        assembly {
            blockNumberBytes := mload(add(blockNumberString, 0x20))
        }

        return (blockNumberBytes, ethirTokenImpl);
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
