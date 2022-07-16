// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

interface IMagicNumber {
  function whatIsTheMeaningOfLife()  external payable returns(uint256);
}


contract MagicNumberSolution is IMagicNumber {
  fallback() override external payable {
      assembly {
         mstore(0x0, 42)
         return(0x0, 32)
     }
  }

} 
