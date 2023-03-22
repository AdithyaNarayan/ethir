// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../interfaces/IEthirTokenFactory.sol";
import "../EthirToken.sol";

contract EthirTokenFactory is IEthirTokenFactory {
    address immutable owner;
    address currentImplementation;

    /// @dev Temporary variable for clone contract to get expiryBlock
    bytes32 expiryBlock;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function getParameters() external view returns (bytes32, address) {
        return (expiryBlock, currentImplementation);
    }

    function deploy(bytes32 expiryBlockNumber)
        public
        returns (address contractAddress)
    {
        expiryBlock = expiryBlockNumber;

        contractAddress = address(new EthirToken{salt: expiryBlockNumber}());

        delete expiryBlock;
    }

    function setImplementation(address implementation) external onlyOwner {
        currentImplementation = implementation;
    }
}
