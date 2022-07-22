// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import { EthernautScript } from "src/common/EthernautScript.sol";

contract SolutionScript is EthernautScript {

    function solve(address payable _instanceAddress) internal override {
    }

    function getLevelAddress() internal view override returns(address) {
        return 0x9451961b7Aea1Df57bc20CC68D72f662241b5493;
    }


}
