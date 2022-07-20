// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import { IDetectionBot, IForta } from "./DoubleEntryPoint.sol";
import "forge-std/Test.sol";


contract DoubleEntryPointSolution is IDetectionBot, Test {
    IForta forta;
    address cryptoVaultAddress;

    constructor(IForta _forta, address _cryptoVaultAddress) public {
        forta = _forta;
        cryptoVaultAddress = _cryptoVaultAddress;
    }

    function handleTransaction(address user, bytes calldata msgData) external override {
        emit log_named_address("Handling transaction with user", user);
        emit log_named_bytes("And calldata", msgData);

        (address to, uint256 value, address origSender) = abi.decode(msgData[4:], (address,uint256,address));

        if(origSender == cryptoVaultAddress) {
            forta.raiseAlert(user);
        }
    }
}
