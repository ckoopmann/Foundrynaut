// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import "forge-std/Test.sol";
import { CryptoVault, DoubleEntryPoint, IForta, LegacyToken } from "src/26_DoubleEntryPoint/DoubleEntryPoint.sol";
import { DoubleEntryPointSolution } from "src/26_DoubleEntryPoint/DoubleEntryPointSolution.sol";
import { IERC20 } from "openzeppelin-contracts/token/ERC20/ERC20.sol";


contract DoubleEntryPointTest is Test {
    CryptoVault cryptoVault;
    address cryptoVaultAddress = 0xD719916C0b0C3a771076a70041573a9D91A457a7;

    IForta forta;
    address fortaAddress;

    DoubleEntryPoint underlyingToken;
    address underlyingAddress;

    LegacyToken legacyToken;
    address legacyTokenAddress = 0xfD9F1EF77983a20781A570A753d91ed4365c91C8;

    DoubleEntryPointSolution detectionBot;


    function setUp() public {
        cryptoVault = CryptoVault(cryptoVaultAddress);

        underlyingAddress = address(cryptoVault.underlying());
        emit log_named_address("underlyingAddress", underlyingAddress);

        assertFalse(underlyingAddress == address(0), "underlying is 0");
        underlyingToken = DoubleEntryPoint(underlyingAddress);

        fortaAddress = address(underlyingToken.forta());
        emit log_named_address("fortaAddress", fortaAddress);
        forta = IForta(fortaAddress);

        legacyToken = LegacyToken(legacyTokenAddress);


        detectionBot = new DoubleEntryPointSolution(forta, cryptoVaultAddress);
    }


    function testUnderlyingTokenBalance() public {
        assertEq(underlyingToken.balanceOf(cryptoVaultAddress), 100 ether, "cryptoVault balance is not 100");
    }

    function testLegacyTokenBalance() public {
        assertEq(legacyToken.balanceOf(cryptoVaultAddress), 100 ether, "cryptoVault balance is not 100");
    }

    function testLegacyTokenDelegate() public {
        assertEq(address(legacyToken.delegate()), underlyingAddress, "Delegate is not the underlying token");
    }

    function testCanDrainUnderlyingToken() public {
        cryptoVault.sweepToken(IERC20(legacyTokenAddress));
        assertEq(underlyingToken.balanceOf(cryptoVaultAddress), 0, "underlying token balance should be zero after");
    }

    function testCantDrainUnderlyingTokenAfterSolution() public {
        address player = underlyingToken.player();
        emit log_named_address("player", player);

        vm.startPrank(player);
        forta.setDetectionBot(address(detectionBot));
        vm.expectRevert("Alert has been triggered, reverting");
        cryptoVault.sweepToken(IERC20(legacyTokenAddress));
        vm.stopPrank();
    }

    function testOwnerCanStillTransferLegacyTokenAfterSolution() public {
        cryptoVault.sweepToken(IERC20(legacyTokenAddress));

        address sweptTokensRecipient = cryptoVault.sweptTokensRecipient();

        assertEq(underlyingToken.balanceOf(sweptTokensRecipient), 100 ether, "Swept token recipient should have received the tokens");

        address player = underlyingToken.player();
        vm.startPrank(player);
        forta.setDetectionBot(address(detectionBot));

        address receiver = address(12345);
        legacyToken.transfer(receiver, 100);
    }

}
