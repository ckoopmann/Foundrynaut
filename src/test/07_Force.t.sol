
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import "ds-test/test.sol";
import { ForceSolution} from "src/07_Force/Solution.sol";
import { Force}  from "src/07_Force/Problem.sol";

contract ContractTest is DSTest {
    Force force;
    ForceSolution forceSolution;

    function setUp() public {
        force = new Force();
        forceSolution = new ForceSolution();
    }

    function testForce() public {
        forceSolution.sendIt{value:10000}(payable(address(force)));
        uint balanceAfter = address(force).balance;
        emit log_named_uint("Balance", balanceAfter);
        // assertGt(balanceAfter, 0, "Balance is zero");
    }
}
