// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import {Script} from "forge-std/Script.sol";
import {EthernautScript} from "src/common/EthernautScript.sol";
import {DoubleEntryPoint, Forta, IDetectionBot} from "./Problem.sol";

contract Solution is IDetectionBot {
    Forta forta;
    address cryptoVaultAddress;

    constructor(Forta _forta, address _cryptoVaultAddress) public {
        forta = _forta;
        cryptoVaultAddress = _cryptoVaultAddress;
    }

    function handleTransaction(address user, bytes calldata msgData)
        external
        override
    {
        (address to, uint256 value, address origSender) =
            abi.decode(msgData[4:], (address, uint256, address));

        if (origSender == cryptoVaultAddress) {
            forta.raiseAlert(user);
        }
    }
}

contract SolutionScript is EthernautScript {
    function solve(address payable _instanceAddress) internal override {
        DoubleEntryPoint doubleEntryPoint = DoubleEntryPoint(_instanceAddress);
        Forta forta = doubleEntryPoint.forta();

        vm.startBroadcast();
        Solution solution = new Solution(forta, doubleEntryPoint.cryptoVault());
        forta.setDetectionBot(address(solution));
        vm.stopBroadcast();
    }

    function getLevelAddress() internal view override returns (address) {
        return 0x128BA32Ec698610f2fF8f010A7b74f9985a6D17c;
    }
}
