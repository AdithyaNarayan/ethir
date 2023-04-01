// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

/// @notice Also follows ERC20 interface
interface IEthirToken {
    // is IERC20 {
    function floatingBalanceOf(address user) external view returns (uint256);
}
