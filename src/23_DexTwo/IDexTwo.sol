// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;


interface IDexTwo {
  function token1() external view returns(address);
  function token2() external view returns(address);
  function setTokens(address _token1, address _token2) external;
  function addLiquidity(address token_address, uint amount) external;
  function swap(address from, address to, uint amount) external;
  function getSwapPrice(address from, address to, uint amount) external view returns(uint);
  function approve(address spender, uint amount) external;
  function balanceOf(address token, address account) external view returns (uint);
}
