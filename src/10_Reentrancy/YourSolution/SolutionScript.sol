// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import { EthernautScript } from "src/common/EthernautScript.sol";

contract SolutionScript is EthernautScript {

    function solve(address payable _instanceAddress) internal override {
    }

    function getLevelAddress() internal view override returns(address) {
        return 0x43BA674B4fbb8B157b7441C2187bCdD2cdF84FD5;
    }

    function getCreationValue() internal view override returns(uint256) {
        return 0.001 ether;
    }
}
