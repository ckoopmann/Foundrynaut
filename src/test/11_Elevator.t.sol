
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import "ds-test/test.sol";
import { IElevator, ElevatorSolution} from "src/11_Elevator/ElevatorSolution.sol";

contract ElevatorTest is DSTest {
    IElevator elevator;
    ElevatorSolution elevatorSolution;

    function setUp() public {
        elevator = IElevator(0x66CdE961FA8a72aa77343C064890A113e3FBbCa9);
        elevatorSolution = new ElevatorSolution();
    }

    function testElevatorBefore() public {
        bool isTop = elevator.top();
        assertTrue(!isTop);
    }

    function testElevatorAfter() public {
        elevatorSolution.goToTheLastFloor(elevator);
        bool isTop = elevator.top();
        assertTrue(isTop);
    }
}
