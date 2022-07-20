// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import "forge-std/Test.sol";
import { IMotorbike } from "src/25_Motorbike/IMotorbike.sol";
import { MotorbikeSolution } from "src/25_Motorbike/MotorbikeSolution.sol";

contract MotorbikeTest is Test {

    IMotorbike motorbike;
    MotorbikeSolution motorbikeSolution;
    address instanceAddress = 0xbb54c6987a695C75DD6Cd01C0F194f202EDA80B0;


    function setUp() public {
        motorbike = IMotorbike(instanceAddress);
        motorbikeSolution = new MotorbikeSolution();
    }


    function testDestroyIt() public {
        bytes32 implementationSlot = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
        address implementation = address(uint160(uint256(vm.load(instanceAddress, implementationSlot))));

        assertFalse(implementation == address(0), "Implementation should not be the zero address");

        // Unfortunately you can't test the effect of a selfdestruct in foundry currently
        // See: https://github.com/foundry-rs/foundry/issues/1543
        motorbikeSolution.killIt(IMotorbike(implementation));
    }


}

contract MotorbikeTestAfterContractIsDestroyed is Test {
    IMotorbike motorbike;
    MotorbikeSolution motorbikeSolution;
    address instanceAddress = 0xbb54c6987a695C75DD6Cd01C0F194f202EDA80B0;
    address implementation;


    function setUp() public {
        motorbike = IMotorbike(instanceAddress);
        motorbikeSolution = new MotorbikeSolution();

        bytes32 implementationSlot = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
        implementation = address(uint160(uint256(vm.load(instanceAddress, implementationSlot))));

        assertFalse(implementation == address(0), "Implementation should not be the zero address");

        // Unfortunately you can't test the effect of a selfdestruct in foundry currently
        // See: https://github.com/foundry-rs/foundry/issues/1543
        motorbikeSolution.killIt(IMotorbike(implementation));

    }

    function testFailContractIsDead() public {
        // TODO: Why does this fail ? Isnt setup executed in a separate call ?
        // assertFalse(isContract(implementation), "Contract should be dead");
    }

    function isContract(address addr) internal returns (bool) {
        uint size;
        assembly { size := extcodesize(addr) }
        return size > 0;
    }
}
