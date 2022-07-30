// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

// The goal of this level is for you to claim ownership of the instance you are given.

//   Things that might help

// Look into Solidity's documentation on the delegatecall low level function, how it works, how it can be used to delegate operations to on-chain libraries, and what implications it has on execution scope.
// Fallback methods
// Method ids

contract Delegate {
    address public owner;

    constructor(address _owner) public {
        owner = _owner;
    }

    function pwn() public {
        owner = msg.sender;
    }
}

contract Delegation {
    address public owner;
    Delegate delegate;

    constructor(address _delegateAddress) public {
        delegate = Delegate(_delegateAddress);
        owner = msg.sender;
    }

    fallback() external {
        (bool result,) = address(delegate).delegatecall(msg.data);
        if (result) {
            this;
        }
    }
}
