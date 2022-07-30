// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import {Script} from "forge-std/Script.sol";
import {EthernautScript} from "src/common/EthernautScript.sol";
import {MagicNum} from "./Problem.sol";

interface IMagicNumberSolution {
    function whatIsTheMeaningOfLife() external view returns (uint256);
}

contract SolutionScript is EthernautScript {
    function solve(address payable _instanceAddress) internal override {
        MagicNum magicNumber = MagicNum(_instanceAddress);

        vm.startBroadcast();
        address solutionAddress =
            deployContract("src/18_MagicNumber/MagicNumberSolution.asm");
        magicNumber.setSolver(solutionAddress);
        vm.stopBroadcast();

        IMagicNumberSolution solution = IMagicNumberSolution(solutionAddress);
        assert(solution.whatIsTheMeaningOfLife() == 42);
    }

    function getLevelAddress() internal view override returns (address) {
        return 0x200d3d9Ac7bFd556057224e7aEB4161fED5608D0;
    }

    // Source: https://github.com/ControlCplusControlV/Foundry-Yulp/blob/main/src/test/lib/YulpDeployer.sol
    function deployContract(string memory fileName) public returns (address) {
        string memory bashCommand = string.concat(
            'cast abi-encode "f(bytes)" $(solc --yul ',
            string.concat(fileName, " --bin | tail -1)")
        );

        string[] memory inputs = new string[](3);
        inputs[0] = "bash";
        inputs[1] = "-c";
        inputs[2] = bashCommand;

        bytes memory encodedBytecode = vm.ffi(inputs);
        bytes memory bytecode = abi.decode(encodedBytecode, (bytes));

        ///@notice deploy the bytecode with the create instruction
        address deployedAddress;
        assembly {
            deployedAddress := create(0, add(bytecode, 0x20), mload(bytecode))
        }

        ///@notice check that the deployment was successful
        require(
            deployedAddress != address(0), "YulDeployer could not deploy contract"
        );

        ///@notice return the address that the contract was deployed to
        return deployedAddress;
    }
}
