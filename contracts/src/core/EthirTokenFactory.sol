// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../interfaces/IEthirTokenFactory.sol";
import "../library/LibTokenAddressGenerator.sol";
import "./token/EthirToken.sol";

contract EthirTokenFactory is IEthirTokenFactory {
    address immutable owner;
    address currentImplementation;
    address collateralManager;
    address oracle;

    /// @dev Temporary variable for clone contract to get expiryBlock
    bytes32 expiryBlock;
    uint256 expiryBlockNumber;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function getParameters()
        external
        view
        returns (
            bytes32,
            address,
            address,
            address,
            uint256
        )
    {
        return (
            expiryBlock,
            currentImplementation,
            collateralManager,
            oracle,
            expiryBlockNumber
        );
    }

    function deploy(uint256 _expiryBlockNumber)
        public
        returns (address contractAddress)
    {
        expiryBlock = LibTokenAddressGenerator.getNumberInBytes32(
            _expiryBlockNumber
        );
        expiryBlockNumber = _expiryBlockNumber;

        contractAddress = address(new EthirToken{salt: expiryBlock}());

        delete expiryBlock;
        delete expiryBlockNumber;
    }

    function setImplementation(address implementation) external onlyOwner {
        currentImplementation = implementation;
    }

    function setCollateralManager(address _collateralManager)
        external
        onlyOwner
    {
        collateralManager = _collateralManager;
    }

    function setOracle(address _oracle) external onlyOwner {
        oracle = _oracle;
    }
}
