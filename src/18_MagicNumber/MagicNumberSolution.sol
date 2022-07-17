// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

interface IMagicNumberSolution {
  function whatIsTheMeaningOfLife()  external view returns(uint256);
}


contract MagicNumberSolution {
  fallback() external payable {
      assembly {
         mstore(0x0, 42)
         return(0x0, 32)
     }
  }
} 
