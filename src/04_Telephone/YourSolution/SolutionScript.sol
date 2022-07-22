// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import { EthernautScript } from "src/common/EthernautScript.sol";

contract SolutionScript is EthernautScript {

    function solve(address payable _instanceAddress) internal override {
    }

    function getLevelAddress() internal view override returns(address) {
        return 0x0b6F6CE4BCfB70525A31454292017F640C10c768;
    }


}
