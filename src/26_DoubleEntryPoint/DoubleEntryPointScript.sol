// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import "forge-std/Script.sol";
import { CryptoVault, DoubleEntryPoint, Forta } from "./DoubleEntryPoint.sol";
import { DoubleEntryPointSolution } from "./DoubleEntryPointSolution.sol";
import { IERC20 } from "openzeppelin-contracts/token/ERC20/ERC20.sol";

contract DoubleEntryPointScript is Script {

    Forta forta;
    address instanceAddress = 0xfD9F1EF77983a20781A570A753d91ed4365c91C8;

    CryptoVault cryptoVault;
    address cryptoVaultAddress = 0xD719916C0b0C3a771076a70041573a9D91A457a7;


    function setUp() public {
        cryptoVault = CryptoVault(cryptoVaultAddress);

        address underlyingAddress = address(cryptoVault.underlying());
        assert(underlyingAddress != address(0));

        DoubleEntryPoint underlyingToken = DoubleEntryPoint(underlyingAddress);
        forta = underlyingToken.forta();
    }

    function run() public {
        vm.startBroadcast();
        DoubleEntryPointSolution detectionBot = new DoubleEntryPointSolution(forta, cryptoVaultAddress);
        forta.setDetectionBot(address(detectionBot));

        vm.stopBroadcast();
    }
}
