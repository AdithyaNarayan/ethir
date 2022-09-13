// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "solmate/tokens/ERC20.sol";

contract EthirFutureToken is ERC20 {
  constructor(string memory name, string memory symbol) ERC20(name, symbol, 8) {}

  // TODO: Remove after demo
  function mint(address to, uint256 amount) public {
    _mint(to, amount);
  }

  function burn(address from, address callAddress, bytes memory data) public returns (bytes memory) {
    uint256 gas = gasleft();
    (, bytes memory result) = callAddress.call(data);
    unchecked {
      gas = gas - gasleft();
    }
    _burn(from, gas);

    return result;
  }

}
