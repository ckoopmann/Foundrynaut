// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.15;

import "forge-std/Test.sol";
import { IMagicNumberSolution, MagicNumberSolution} from "src/18_MagicNumber/MagicNumberSolution.sol";
import { MagicNumber } from "src/18_MagicNumber/MagicNumber.sol";

contract MagicNumberTest is Test {

    IMagicNumberSolution magicNumberSolution;
    address solutionAddress;
    MagicNumber magicNumberProd;
    address newOwner;
    address oldOwner;


    function setUp() public {
        solutionAddress = deployContract("src/18_MagicNumber/MagicNumberSolution.asm");
        magicNumberSolution = IMagicNumberSolution(solutionAddress);
    }

    function testMagicNumberSolution() public {
        assertEq(magicNumberSolution.whatIsTheMeaningOfLife(), 42);
    }

    // TODO: Factor out to library
    function deployContract(string memory fileName) public returns (address) {
        string memory bashCommand = string.concat('cast abi-encode "f(bytes)" $(solc --yul ', string.concat(fileName, " --bin | tail -1)"));

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
            deployedAddress != address(0),
            "YulDeployer could not deploy contract"
        );

        ///@notice return the address that the contract was deployed to
        return deployedAddress;
    }


}
