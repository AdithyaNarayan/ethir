// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../library/LibTokenAddressGenerator.sol";
import "../interfaces/IEthirOracle.sol";
import "../interfaces/IEthirToken.sol";
import "../interfaces/IEthirCollateralManager.sol";

contract EthirCollateralManager is IEthirCollateralManager {
    uint256 constant IOTA_EXPONENT = 10**9;

    mapping(address => uint256) collaterals;

    /// @notice List of tokens for a particular repeater with active floating balance
    mapping(address => uint256[]) activeTokens;

    IEthirOracle immutable oracle;

    constructor(address _oracle) {
        oracle = IEthirOracle(_oracle);
    }

    function depositCollateral() external payable {
        unchecked {
            collaterals[msg.sender] += msg.value;
        }
    }

    function withdrawCollateral(uint256 amount) external {
        collaterals[msg.sender] -= amount;
        (uint256 healthFactor, ) = getHealthFactor(msg.sender);
        require(
            healthFactor > IOTA_EXPONENT,
            "Collateral withdrawal leads to unsafe health factor"
        );
    }

    function getHealthFactor(address user) public view returns (uint256, bool) {
        uint256 totalFloatingValue = 0;
        bool isExpired = false;

        uint256[] storage expiryBlocks = activeTokens[user];

        for (uint256 i = 0; i < expiryBlocks.length; i++) {
            uint256 expiryBlock = expiryBlocks[i];
            if (expiryBlock < block.number) {
                isExpired = true;
            }

            uint256 floatingBalance = IEthirToken(
                LibTokenAddressGenerator.getTokenFor(
                    expiryBlock,
                    oracle.factory()
                )
            ).floatingBalanceOf(user) * oracle.getValueInWei(expiryBlock);

            totalFloatingValue += floatingBalance;
        }

        // if no total floating value, shouldn't be infinity
        if (totalFloatingValue == 0) {
            return (2**256 - 1, isExpired);
        }

        return (
            ((collaterals[user] * IOTA_EXPONENT) / totalFloatingValue),
            isExpired
        );
    }
}
