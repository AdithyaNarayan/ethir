// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {LibString} from "solady/utils/LibString.sol";
import "../EthirToken.sol";

library LibTokenAddressGenerator {
    bytes32 public constant INIT_CODE_HASH =
        keccak256(abi.encodePacked(type(EthirToken).creationCode));

    function getNumberInBytes32(uint256 number)
        external
        pure
        returns (bytes32)
    {
        string memory blockNumberString = LibString.toString(number);

        bytes32 blockNumberBytes;
        assembly {
            blockNumberBytes := mload(add(blockNumberString, 0x20))
        }

        return blockNumberBytes;
    }

    function getTokenFor(uint256 expiryBlockNumber, address factory)
        internal
        pure
        returns (address token)
    {
        string memory blockNumberString = LibString.toString(expiryBlockNumber);

        bytes32 blockNumberBytes;
        assembly {
            blockNumberBytes := mload(add(blockNumberString, 0x20))
        }

        token = address(
            uint160(
                uint256(
                    keccak256(
                        abi.encodePacked(
                            hex"ff",
                            factory,
                            blockNumberBytes,
                            INIT_CODE_HASH
                        )
                    )
                )
            )
        );
    }
}
