// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "openzeppelin-contracts/math/SafeMath.sol";

// The goal of this level is for you to steal all the funds from the contract.

//   Things that might help:

// Untrusted contracts can execute code where you least expect it.
// Fallback methods
// Throw/revert bubbling
// Sometimes the best way to attack a contract is with another contract.
// See the Help page above, section "Beyond the console"
contract Reentrance {
    using SafeMath for uint256;

    mapping(address => uint256) public balances;

    function donate(address _to) public payable {
        balances[_to] = balances[_to].add(msg.value);
    }

    function balanceOf(address _who) public view returns (uint256 balance) {
        return balances[_who];
    }

    function withdraw(uint256 _amount) public {
        if (balances[msg.sender] >= _amount) {
            (bool result,) = msg.sender.call{value: _amount}("");
            if (result) {
                _amount;
            }
            balances[msg.sender] -= _amount;
        }
    }

    receive() external payable {}
}
