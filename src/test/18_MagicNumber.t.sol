// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import "forge-std/Test.sol";
import { MagicNumberSolution} from "src/18_MagicNumber/MagicNumberSolution.sol";
import { MagicNumber } from "src/18_MagicNumber/MagicNumber.sol";

contract MagicNumberTest is Test {

    MagicNumberSolution magicNumberSolution;
    MagicNumber magicNumberProd;
    address newOwner;
    address oldOwner;


    function setUp() public {
        magicNumberSolution = new MagicNumberSolution();
    }

    function testMagicNumberSolution() public {
        assertEq(magicNumberSolution.whatIsTheMeaningOfLife(), 42);
    }

}
