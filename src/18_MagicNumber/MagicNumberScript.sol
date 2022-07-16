// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import "forge-std/Script.sol";
import { MagicNumberSolution} from "src/18_MagicNumber/MagicNumberSolution.sol";
import { MagicNumber } from "src/18_MagicNumber/MagicNumber.sol";

contract MagicNumberScript is Script {

    MagicNumberSolution magicNumberSolution;
    MagicNumber magicNumberProd;
    address oldOwner;


    function setUp() public {
        magicNumberProd = MagicNumber(0x03635126180422206b36e8aaAfFbcC7B91993be5);
    }

    function run() public {
        vm.startBroadcast();
        magicNumberSolution = new MagicNumberSolution();
        magicNumberProd.setSolver(address(magicNumberSolution));
        vm.stopBroadcast();
    }

}
