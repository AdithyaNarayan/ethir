// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IEthirOracle {
    function getValueInETH(uint256 expiryBlockNumber)
        external
        view
        returns (uint256);
}
