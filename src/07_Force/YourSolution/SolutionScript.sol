// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import { EthernautScript } from "src/common/EthernautScript.sol";

contract SolutionScript is EthernautScript {

    function solve(address payable _instanceAddress) internal override {
    }

    function getLevelAddress() internal view override returns(address) {
        return 0x22699e6AdD7159C3C385bf4d7e1C647ddB3a99ea;
    }


}
