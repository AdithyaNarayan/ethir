// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/EthirFutureToken.sol";

contract CounterTest is Test {
    EthirFutureToken public token;
    function setUp() public {
       token = new EthirFutureToken("Ethir 15-Oct-2022 6:00PM", "ETHIR-151020221800");
    }
}
