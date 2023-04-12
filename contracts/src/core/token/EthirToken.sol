// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../../interfaces/IEthirTokenFactory.sol";

/// @title Ethir Token
/// @notice Minimal Proxy contract that represents a token that expires at a particular block
/// @dev Implements name() and symbol() internally and delegatecalls EthirTokenImpl for the rest of the ERC20 functions
contract EthirToken {
    address immutable implementation;

    constructor() {
        (
            bytes32 _expiryBlock,
            address _implementation,
            address _collateralManager,
            address _oracle,
            uint256 _expiryBlockNumber
        ) = IEthirTokenFactory(msg.sender).getParameters();

        implementation = _implementation;

        assembly {
            sstore(0, _expiryBlock)
            sstore(1, _collateralManager)
            sstore(2, _oracle)
            sstore(3, _expiryBlockNumber)
        }
    }

    fallback() external payable {
        assembly {
            switch shr(0xe0, calldataload(0))
            // selector for "name()"
            case 0x06fdde03 {
                mstore(0x00, 0x20) // offset for string length

                mstore(0x40, shl(0xb0, 0x45746869722047617320)) // hex of "Ethir Gas " shifted to start of 32 byte block
                mstore(0x4A, sload(0)) // block number into next block

                let data := mload(0x4A)
                let cur_byte := 0x1
                let i := 0

                for {

                } iszero(iszero(cur_byte)) {
                    i := add(i, 1)
                } {
                    cur_byte := shr(0xf8, and(shl(0xf8, 0xff), data))

                    data := shl(0x8, data)
                }

                mstore(0x20, add(0x9, i)) // string length

                return(0, 0x60)
            }
            // selector for "symbol()"
            case 0x95d89b41 {
                mstore(0x00, 0x20) // offset for string length

                mstore(0x40, shl(0xe0, 0x4741532d)) // hex of "GAS-" shifted to start of 32 byte block
                mstore(0x44, sload(0)) // block number into next byte slot

                let data := mload(0x44)
                let cur_byte := 0x1
                let i := 0

                for {

                } iszero(iszero(cur_byte)) {
                    i := add(i, 1)
                } {
                    cur_byte := shr(0xf8, and(shl(0xf8, 0xff), data))

                    data := shl(0x8, data)
                }

                mstore(0x20, add(0x3, i)) // string length

                return(0, 0x60)
            }
            // transfer of funds
            case 0x0 {
                return(0, 0x0)
            }
        }

        address impl = implementation;
        assembly {
            calldatacopy(0x0, 0x0, calldatasize())
            let result := delegatecall(gas(), impl, 0x0, calldatasize(), 0x0, 0)

            if iszero(result) {
                revert(0, 0)
            }

            returndatacopy(0x0, 0x0, returndatasize())
            return(0, returndatasize())
        }
    }
}
