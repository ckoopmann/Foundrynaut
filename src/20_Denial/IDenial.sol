// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;


interface IDenial {
    function setWithdrawPartner(address _partner) external;
    // withdraw 1% to recipient and 1% to owner
    function withdraw() external;
    // convenience function
    function contractBalance() external view returns (uint);
    function withdrawPartnerBalances(address) external view returns (uint);
    function owner() external view returns (address);
    function partner() external view returns (address);
}
