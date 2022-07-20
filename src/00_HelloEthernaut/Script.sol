// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import "forge-std/Test.sol";
import { Instance } from "./Problem.sol";
import { IEthernaut } from "../common/IEthernaut.sol";
import { ILevel } from "../common/ILevel.sol";

contract HelloEthernautScript is Test {

    address levelAddress = 0x4E73b858fD5D7A5fc1c3455061dE52a53F35d966;
    IEthernaut constant ethernaut= IEthernaut(0xD991431D8b033ddCb84dAD257f4821E9d5b38C33);
    uint256 creationValue = 0;
    StaticCaller staticCaller;


    function setUp() public {
         staticCaller = new StaticCaller();
    }

    function run() public {
        address payable instanceAddress = payable(abi.decode(callStatic(levelAddress, abi.encodeWithSignature("createInstance(address)", tx.origin)), (address)));

        emit log_named_address("Instance address", instanceAddress);
        createLevel(instanceAddress);

        solve(instanceAddress);

        submitLevel(instanceAddress);
    }

    function solve(address payable _instanceAddress) internal {
        vm.startBroadcast();
        Instance instance = Instance(_instanceAddress);
        instance.authenticate(instance.password());
        vm.stopBroadcast();
    }

    function createLevel(address payable _instanceAddress) internal {
        vm.startBroadcast();
        ethernaut.createLevelInstance{value: creationValue}(levelAddress);
        // assert(ethernaut.emittedInstances(_instanceAddress).player == tx.origin);
        vm.stopBroadcast();
    }

    function submitLevel(address payable _instanceAddress) internal {
        assert(ILevel(levelAddress).validateInstance(_instanceAddress, tx.origin));
        vm.startBroadcast();
        ethernaut.submitLevelInstance(_instanceAddress);
        vm.stopBroadcast();
    }

    function callStatic(
        address targetContract,
        bytes memory calldataPayload
    ) internal returns(bytes memory) {
        bytes memory nestedCallData = abi.encodeWithSignature("simulateAndRevert(address,bytes)", targetContract, calldataPayload);
        (bool success, bytes memory returnData) = address(staticCaller).call(nestedCallData);
        return returnData;
    }

}

contract StaticCaller {


    function simulateAndRevert(
        address targetContract,
        bytes memory calldataPayload
    ) external returns (bytes memory response) {
        (,bytes memory returnData) = targetContract.call(calldataPayload);
        assembly {
            let ptr := mload(0x40)
            let size := returndatasize()
            returndatacopy(ptr, 0, size)
            revert(ptr, size)
        }
    }

}
