// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.6.0;

import "forge-std/Test.sol";
import {IEthernaut} from "../common/IEthernaut.sol";
import {ILevel} from "../common/ILevel.sol";

// TODO: Originally wanted to make this abstract but then forge failed with "compiled contract not found" - Investigate
contract EthernautScript is Test {
    IEthernaut constant ethernaut =
        IEthernaut(0xD991431D8b033ddCb84dAD257f4821E9d5b38C33);
    bool validateInstance = true;

    function run() public {
        uint256 snapshot = vm.snapshot();
        address payable instanceAddress = getInstanceAddress();
        vm.revertTo(snapshot);

        createLevel();

        solve(instanceAddress);

        submitLevel(instanceAddress);
    }

    function createLevel() internal {
        vm.startBroadcast();
        ethernaut.createLevelInstance{value: getCreationValue()}(
            getLevelAddress()
        );
        vm.stopBroadcast();
    }

    function submitLevel(address payable _instanceAddress) internal {
        if (validateInstance) {
            assert(
                ILevel(getLevelAddress()).validateInstance(_instanceAddress, tx.origin)
            );
        }
        vm.startBroadcast();
        ethernaut.submitLevelInstance(_instanceAddress);
        vm.stopBroadcast();
    }

    function getInstanceAddress() internal returns (address payable) {
        address instanceAddress = ILevel(getLevelAddress()).createInstance{
            value: getCreationValue()
        }(tx.origin);
        return payable(instanceAddress);
    }

    function getLevelAddress() internal view virtual returns (address) {
        revert("You need to implement a getLevelAddress method");
    }

    function solve(address payable _instanceAddress) internal virtual {
        revert("You need to implement a solve method");
    }

    function getCreationValue() internal view virtual returns (uint256) {
        return 0;
    }
}
