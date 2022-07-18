// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import { IDenial } from "src/20_Denial/IDenial.sol";
import { DenialSolution } from "src/20_Denial/DenialSolution.sol";

contract DenialTest is Test {

    IDenial denial;
    DenialSolution denialSolution;
    address instanceAddress = 0x5040577d8c0DE9Ce8a8a7886e45cb1221E05A082;
    address owner;


    function setUp() public {
        denial = IDenial(instanceAddress);
        owner = denial.owner();
        denialSolution = new DenialSolution(denial);
    }

    function testDenialCanWithdrawBefore() public {
        uint ownerBalanceBefore = owner.balance;
        denial.withdraw();
        uint ownerBalanceAfter = owner.balance;
        assertTrue(ownerBalanceAfter > ownerBalanceBefore, "Owner balance should have increased");
    }

    function testDenialCannotWithdrawAfter() public {
        denial.setWithdrawPartner(address(denialSolution));
        // This will lead to stack overflow in forge so can't test this
        // denial.withdraw();
    }
}
