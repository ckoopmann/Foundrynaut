// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;


interface IAlienCodex {


  function owner() external view returns(address);
  function contact() external view returns(bool);
  function codex(uint i) external view returns(bytes32);

  function make_contact() external;

  function record(bytes32 _content) external;

  function retract() external;

  function revise(uint i, bytes32 _content) external;
}
