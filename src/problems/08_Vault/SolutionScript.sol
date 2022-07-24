// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import { Script } from "forge-std/Script.sol";
import { EthernautScript } from "src/common/EthernautScript.sol";
import { Vault } from "./Problem.sol";

contract SolutionScript is EthernautScript {

    function solve(address payable _instanceAddress) internal override {
        vm.startBroadcast();
        Vault problem = Vault(_instanceAddress);
        bytes32 password = vm.load(_instanceAddress, bytes32(uint256(1)));
        problem.unlock(password);
        assert(problem.locked() == false);
        vm.stopBroadcast();
    }

    function getLevelAddress() internal view override returns(address) {
        return 0xf94b476063B6379A3c8b6C836efB8B3e10eDe188;
    }
}

