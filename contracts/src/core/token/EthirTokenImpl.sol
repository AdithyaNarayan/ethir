// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {LibString} from "solady/utils/LibString.sol";
import "../../interfaces/IEthirCollateralManager.sol";
import "../../interfaces/IEthirOracle.sol";

/// @title Ethir Token Implementation
/// @notice Partial Implementation of ERC20 for use in Clone Pattern (EIP-1167)
/// @dev Implementation from Solady/ERC20
contract EthirTokenImpl {
    struct Slot0 {
        bytes32 expiryBlock;
    }
    struct Slot1 {
        IEthirCollateralManager collateralManager;
    }
    struct Slot2 {
        IEthirOracle oracle;
    }
    struct Slot3 {
        uint256 expiryBlockNumber;
    }

    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 amount
    );

    uint8 immutable ALPHA = 70;

    Slot0 slot0;
    Slot1 slot1;
    Slot2 slot2;
    Slot3 slot3;

    uint8 public constant decimals = 8;

    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;

    mapping(address => mapping(address => uint256)) public allowance;

    /// @notice Denotes the balance that the user has minted that is yet to be burnt
    mapping(address => uint256) public floatingBalanceOf;
    mapping(address => uint256) public burnRewards;

    function mint(
        address to,
        uint256 amount,
        address callback,
        bytes calldata data
    ) public payable {
        _mint(to, amount);

        unchecked {
            floatingBalanceOf[to] += amount;
        }

        (uint256 healthFactor, ) = IEthirCollateralManager(
            slot1.collateralManager
        ).getHealthFactor(to);

        require(
            healthFactor > 10**9,
            "Cannot mint due to insufficient collateral"
        );

        uint256 balanceBefore = address(this).balance;
        (bool success, ) = callback.call(data);
        require(success);
        require(
            address(this).balance - balanceBefore >
                (ALPHA *
                    slot2.oracle.getValueInWei(slot3.expiryBlockNumber) *
                    amount) /
                    100
        );

        burnRewards[to] += address(this).balance - balanceBefore;
    }

    function burn(
        address from,
        address callAddress,
        bytes memory data
    ) public returns (bytes memory) {
        uint256 gas = gasleft();
        (, bytes memory result) = callAddress.call(data);
        unchecked {
            gas = gas - gasleft();
        }
        _burn(from, gas);

        uint256 burnReward = (burnRewards[msg.sender] * gas) /
            floatingBalanceOf[msg.sender];

        burnRewards[msg.sender] -= burnReward;
        floatingBalanceOf[msg.sender] -= gas;

        payable(msg.sender).transfer(burnReward);

        return result;
    }

    /*//////////////////////////////////////////////////////////////
                               ERC20 LOGIC
    //////////////////////////////////////////////////////////////*/

    function approve(address spender, uint256 amount)
        public
        virtual
        returns (bool)
    {
        allowance[msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, amount);

        return true;
    }

    function transfer(address to, uint256 amount)
        public
        virtual
        returns (bool)
    {
        balanceOf[msg.sender] -= amount;

        // Cannot overflow because the sum of all user
        // balances can't exceed the max uint256 value.
        unchecked {
            balanceOf[to] += amount;
        }

        emit Transfer(msg.sender, to, amount);

        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual returns (bool) {
        uint256 allowed = allowance[from][msg.sender]; // Saves gas for limited approvals.

        if (allowed != type(uint256).max) {
            allowance[from][msg.sender] = allowed - amount;
        }

        balanceOf[from] -= amount;

        // Cannot overflow because the sum of all user
        // balances can't exceed the max uint256 value.
        unchecked {
            balanceOf[to] += amount;
        }

        emit Transfer(from, to, amount);

        return true;
    }

    /*//////////////////////////////////////////////////////////////
                        INTERNAL MINT/BURN LOGIC
    //////////////////////////////////////////////////////////////*/

    function _mint(address to, uint256 amount) internal virtual {
        totalSupply += amount;

        // Cannot overflow because the sum of all user
        // balances can't exceed the max uint256 value.
        unchecked {
            balanceOf[to] += amount;
        }

        emit Transfer(address(0), to, amount);
    }

    function _burn(address from, uint256 amount) internal virtual {
        balanceOf[from] -= amount;

        // Cannot underflow because a user's balance
        // will never be larger than the total supply.
        unchecked {
            totalSupply -= amount;
        }

        emit Transfer(from, address(0), amount);
    }
}
