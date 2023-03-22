// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../interfaces/IEthirOracle.sol";

contract EthirCollateralManager {
    mapping(address => uint256) collaterals;

    IEthirOracle oracle;

    function depositCollateral() external payable {
        unchecked {
            collaterals[msg.sender] += msg.value;
        }
    }

    function withdrawCollateral(uint256 amount) external {
        collaterals[msg.sender] -= amount;
        // TODO: Validate
    }

    function getHealthFactor(address user) external view returns (uint256) {
        return collaterals[user] / oracle.getValueInETH(address(0x0), 0x0);
    }
}
