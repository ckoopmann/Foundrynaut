// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;

// Had to assume ownable implementation since it wasn't shown in the problem
contract Ownable {
    address public owner;

    constructor() public {
        owner = msg.sender;
    }
}

contract AlienCodex is Ownable {
    bool public contact;
    bytes32[] public codex;

    modifier contacted() {
        assert(contact);
        _;
    }

    function make_contact() public {
        contact = true;
    }

    function record(bytes32 _content) public contacted {
        codex.push(_content);
    }

    function retract() public contacted {
        codex.length--;
    }

    function revise(uint256 i, bytes32 _content) public contacted {
        codex[i] = _content;
    }
}
