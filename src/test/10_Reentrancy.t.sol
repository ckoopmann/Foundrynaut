
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import "ds-test/test.sol";
import { IReentrancy, ReentrancySolution} from "src/10_Reentrancy/ReentrancySolution.sol";

contract ReentrancyTest is DSTest {
    IReentrancy reentrancy;
    ReentrancySolution reentrancySolution;

    function setUp() public {
        reentrancy = IReentrancy(0x62733a43F7021d2c25fF8409E4cD576F1BF3d04F);
        reentrancySolution = new ReentrancySolution();
    }

    function testReentrancyBefore() public {
        uint totalBalance = address(reentrancy).balance;
        emit log_named_uint("totalBalance", totalBalance);
        uint myBalance = address(this).balance;
        emit log_named_uint("myBalance", myBalance);
    }

    function testReentrancyDrainIt() public {
        uint totalBalance = address(reentrancy).balance;
        uint myBalanceBefore = address(this).balance;
        reentrancySolution.drainIt{value: totalBalance}(reentrancy);
        uint myBalanceAfter = address(this).balance;
        uint contractBalaceAfter = address(reentrancy).balance;
        assertGt(myBalanceAfter, myBalanceBefore);
        assertEq(contractBalaceAfter, 0);
    }

    receive() external payable {
        emit log_named_uint("Received prize", msg.value);
    }
}
