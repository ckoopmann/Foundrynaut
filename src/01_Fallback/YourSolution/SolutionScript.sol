// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import { EthernautScript } from "src/common/EthernautScript.sol";
import { Fallback } from "../Problem.sol";

contract SolutionScript is EthernautScript {

    function solve(address payable _instanceAddress) internal override {
    }

    function getLevelAddress() internal view override returns(address) {
        return 0x9CB391dbcD447E645D6Cb55dE6ca23164130D008;
    }


}
