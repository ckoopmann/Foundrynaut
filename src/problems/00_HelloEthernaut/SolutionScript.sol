// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import {EthernautScript} from "src/common/EthernautScript.sol";
import {Instance} from "./Problem.sol";

contract SolutionScript is EthernautScript {
    function solve(address payable _instanceAddress) internal override {
        vm.startBroadcast();
        Instance instance = Instance(_instanceAddress);
        instance.authenticate(instance.password());
        vm.stopBroadcast();
    }

    function getLevelAddress() internal view override returns (address) {
        return 0x4E73b858fD5D7A5fc1c3455061dE52a53F35d966;
    }
}
