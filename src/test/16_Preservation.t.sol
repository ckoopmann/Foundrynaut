// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import "forge-std/Test.sol";
import { PreservationSolution} from "src/16_Preservation/PreservationSolution.sol";
import { Preservation } from "src/16_Preservation/Preservation.sol";

contract PreservationTest is Test {

    PreservationSolution preservationSolution;
    Preservation preservationProd;
    address newOwner;
    address oldOwner;


    function setUp() public {
        preservationProd = Preservation(0x03635126180422206b36e8aaAfFbcC7B91993be5);
    }

    function testPreservation() public {
        newOwner = tx.origin;

        oldOwner = preservationProd.owner();
        assert(oldOwner != address(0));

        preservationSolution = new PreservationSolution();
        preservationSolution.changeOwner(address(preservationProd));
        assertEq(preservationProd.owner(), newOwner);
    }

}
