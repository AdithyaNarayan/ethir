// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IEthirTokenFactory {
    function getParameters()
        external
        view
        returns (
            bytes32,
            address,
            address,
            address,
            uint256
        );
}
