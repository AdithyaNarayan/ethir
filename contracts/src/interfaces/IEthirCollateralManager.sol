// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IEthirCollateralManager {
    function getHealthFactor(address user)
        external
        view
        returns (uint256, bool);
}
