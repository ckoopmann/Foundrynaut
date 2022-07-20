// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;


interface IMotorbike {
    function upgrader() external view returns (address);
    function horsePower() external view returns (uint256);
    function initialize() external;
    function upgradeToAndCall(address newImplementation, bytes memory data) external payable;
}
