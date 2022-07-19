// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import "forge-std/Test.sol";
import { IPuzzleWallet } from "src/24_PuzzleWallet/IPuzzleWallet.sol";
import { PuzzleWalletSolution } from "src/24_PuzzleWallet/PuzzleWalletSolution.sol";

contract PuzzleWalletTest is Test {

    IPuzzleWallet puzzleWallet;
    PuzzleWalletSolution puzzleWalletSolution;
    address instanceAddress = 0xAf5a6f5E2c7E8c5c9d2398C1b4b8E91027385c5b;
    address user = 0x6f31C2943866bFA792884F6579906BeE388D1C7A;


    function setUp() public {
        puzzleWallet = IPuzzleWallet(instanceAddress);
        puzzleWalletSolution = new PuzzleWalletSolution();
    }


    function testSwapBackAndForth() public {
        vm.startPrank(user);
        vm.stopPrank();
    }

}
