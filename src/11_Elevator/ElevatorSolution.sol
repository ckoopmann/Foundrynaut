// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

interface IBuilding {
  function isLastFloor(uint) external returns(bool);
}

interface IElevator {
    function goTo(uint _floor) external;
    function top() external view returns(bool);
    function floor() external view returns(uint);
}


contract ElevatorSolution is IBuilding {
  bool public _isLastFloor;

  function isLastFloor(uint) external override returns(bool){
      bool returnValue = _isLastFloor;
      _isLastFloor = !_isLastFloor;
      return returnValue;
  }

  function goToTheLastFloor(IElevator _elevator) external {
      _elevator.goTo(1);
  }
}
