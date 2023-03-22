// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./EthirFutureToken.sol";

contract EthirFutureTokenFactory {
    function deploy(string memory name, string memory symbol) public returns (address) {
        bytes32 salt;
        bytes memory symbolBytes = bytes(symbol);

        assembly {
            salt := mload(add(symbolBytes, 32))
        }

        return address(new EthirFutureToken{salt: salt}(name, symbol));
    }
}
