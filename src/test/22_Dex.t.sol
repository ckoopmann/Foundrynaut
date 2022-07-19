// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import "forge-std/Test.sol";
import { IDex } from "src/22_Dex/IDex.sol";
import { DexSolution } from "src/22_Dex/DexSolution.sol";

contract DexTest is Test {

    IDex dex;
    DexSolution dexSolution;
    address instanceAddress = 0xAf5a6f5E2c7E8c5c9d2398C1b4b8E91027385c5b;
    address token1;
    address token2;
    address user = 0x6f31C2943866bFA792884F6579906BeE388D1C7A;


    function setUp() public {
        dex = IDex(instanceAddress);
        token1 = dex.token1();
        token2 = dex.token2();
        dexSolution = new DexSolution();
    }


    function testSwapBackAndForth() public {
        vm.startPrank(user);
        dex.approve(address(dexSolution), type(uint256).max);

        dexSolution.drainIt(dex);
        assertEq(dex.balanceOf(token1, address(dex)), 0, "Input token balance should be 0");
        

        vm.stopPrank();
    }




}
