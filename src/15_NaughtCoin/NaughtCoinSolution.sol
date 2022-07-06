// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
import 'lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol';


contract NaughtCoinSolution {

    function transferIn(address token) external {
        IERC20(token).transferFrom(msg.sender, address(this), IERC20(token).balanceOf(msg.sender));
    }

    function approveMe(address token)  external {
        IERC20(token).approve(msg.sender, IERC20(token).balanceOf(address(this)));
    }
} 
