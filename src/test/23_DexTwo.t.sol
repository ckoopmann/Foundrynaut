// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import "forge-std/Test.sol";
import { IDexTwo } from "src/23_DexTwo/IDexTwo.sol";
import { DexTwoSolution } from "src/23_DexTwo/DexTwoSolution.sol";

contract DexTwoTest is Test {

    IDexTwo dex;
    DexTwoSolution dexSolution;
    address instanceAddress = 0x62bDbe73427e419dee85335b2F4207813eAb1ada;
    address token1;
    address token2;
    address user = 0x6f31C2943866bFA792884F6579906BeE388D1C7A;


    function setUp() public {
        dex = IDexTwo(instanceAddress);
        token1 = dex.token1();
        token2 = dex.token2();
        dexSolution = new DexTwoSolution();
    }


    function testDrainToken1() public {
        dexSolution.drainIt(dex, true);
        assertEq(dex.balanceOf(token1, address(dex)), 0, "Token1 balance should be 0");
        assertEq(dex.balanceOf(token1, address(this)), 100, "Caller should have all tokens");
    }

    function testDrainToken2() public {
        dexSolution.drainIt(dex, false);
        assertEq(dex.balanceOf(token2, address(dex)), 0, "Token2 balance should be 0");
        assertEq(dex.balanceOf(token2, address(this)), 100, "Caller should have all tokens");
    }

}
