// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/interfaces/IEthirTokenFactory.sol";
import "../src/core/EthirTokenFactory.sol";
import "../src/core/token/EthirTokenImpl.sol";
import "../src/core/token/EthirToken.sol";

import "../src/library/LibTokenAddressGenerator.sol";

contract LibTokenAddressGeneratorTest is Test {
    address tokenImpl;
    address factory;

    function setUp() external {
        tokenImpl = address(new EthirTokenImpl());
        factory = address(new EthirTokenFactory());

        EthirTokenFactory(factory).setImplementation(tokenImpl);
    }

    function testBytes32Conversion() external {
        uint256 num = 123;
        assertEq(LibTokenAddressGenerator.getNumberInBytes32(num), "123");

        num = 456;
        assertEq(LibTokenAddressGenerator.getNumberInBytes32(num), "456");

        num = 789;
        assertEq(LibTokenAddressGenerator.getNumberInBytes32(num), "789");
    }

    function testAddressGenerationFromBlockNumber() external {
        address token2049 = EthirTokenFactory(factory).deploy(2049);

        assertEq(
            LibTokenAddressGenerator.getTokenFor(2049, factory),
            token2049
        );
    }
}
