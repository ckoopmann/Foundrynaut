// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import "forge-std/Test.sol";
import { IEthernaut } from "../common/IEthernaut.sol";
import { ILevel } from "../common/ILevel.sol";

// TODO: Originally wanted to make this abstract but then forge failed with "compiled contract not found" - Investigate
contract EthernautScript is Test {

    IEthernaut constant ethernaut= IEthernaut(0xD991431D8b033ddCb84dAD257f4821E9d5b38C33);


    function run() public {
        address payable instanceAddress = getInstanceAddress();

        createLevel();

        solve(instanceAddress);

        submitLevel(instanceAddress);
    }

    function createLevel() internal {
        vm.startBroadcast();
        ethernaut.createLevelInstance{value: getCreationValue()}(getLevelAddress());
        vm.stopBroadcast();
    }

    function submitLevel(address payable _instanceAddress) internal {
        assert(ILevel(getLevelAddress()).validateInstance(_instanceAddress, tx.origin));
        vm.startBroadcast();
        ethernaut.submitLevelInstance(_instanceAddress);
        vm.stopBroadcast();
    }

    function getInstanceAddress() internal returns(address payable) {
        address staticCaller = address(new StaticCaller());
        return payable(abi.decode(callStatic(staticCaller, getLevelAddress(), abi.encodeWithSignature("createInstance(address)", tx.origin), getCreationValue()), (address)));
    }

    function callStatic(
        address staticCaller,
        address targetContract,
        bytes memory calldataPayload,
        uint256 value
    ) internal returns(bytes memory) {
        bytes memory nestedCallData = abi.encodeWithSignature("simulateAndRevert(address,bytes)", targetContract, calldataPayload);
        (bool success, bytes memory returnData) = address(staticCaller).call{value: value}(nestedCallData);
        return returnData;
    }

    function getLevelAddress() internal virtual view returns(address) {
        revert("You need to implement a getLevelAddress method");
    }

    function solve(address payable _instanceAddress) internal virtual {
        revert("You need to implement a solve method");
    }

    function getCreationValue() internal view virtual returns(uint) {
        return 0;
    }
}    

contract StaticCaller {


    function simulateAndRevert(
        address targetContract,
        bytes memory calldataPayload
    ) external payable returns (bytes memory response) {
        (,bytes memory returnData) = targetContract.call{value: msg.value}(calldataPayload);
        assembly {
            let ptr := mload(0x40)
            let size := returndatasize()
            returndatacopy(ptr, 0, size)
            revert(ptr, size)
        }
    }

}

