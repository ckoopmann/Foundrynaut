// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import {Script} from "forge-std/Script.sol";
import {EthernautScript} from "src/common/EthernautScript.sol";
import {Gatekeeper} from "./Problem.sol";

import "openzeppelin-contracts/math/SafeMath.sol";

contract Solution {
    using SafeMath for uint256;

    uint256 randomValue;

    event GasBurned(uint256 indexed iteration);

    function breakIn(uint256 gasLimit, bytes8 key, Gatekeeper gatekeeper)
        external
    {
        // I had to add this gas burning since otherwise forge script would run this transaction with gas limit set lower than the one specified in the function argument
        // TODO: Once forge supports specifying gas per tx, remove this (as well as the rest of the contract)
        burnGas(gasLimit);
        gatekeeper.enter{gas: gasLimit}(key);
    }

    function burnGas(uint256 gasLimit) private {
        uint256 iterations = 30;
        for (uint256 i = 0; i < iterations; i++) {
            randomValue = randomValue + 1;
            emit GasBurned(i);
            if (gasleft().sub(gasLimit) < 50000) {
                return;
            }
        }
    }
}

contract SolutionScript is EthernautScript {
    function solve(address payable _instanceAddress) internal override {
        Gatekeeper gatekeeper = Gatekeeper(_instanceAddress);

        // This value was determined with a fuzz test
        // TODO: Find a better way to determine this dynamically
        uint256 gasLimit = 41209;

        uint64 gateKeyUint = uint64(uint16(tx.origin));
        bytes8 key = bytes8(gateKeyUint);
        assert(uint32(uint64(key)) == uint16(uint64(key)));
        // Add a 1 bit in between bit 32 and 64
        gateKeyUint = gateKeyUint + 2 ** 33;
        key = bytes8(gateKeyUint);
        assert(uint32(uint64(key)) != uint64(key));
        assert(uint32(uint64(key)) == uint16(tx.origin));

        uint256 blockNumber = block.number;

        vm.startBroadcast();
        Solution solution = new Solution();
        solution.breakIn(gasLimit, key, gatekeeper);
        vm.stopBroadcast();

        assert(gatekeeper.entrant() == tx.origin);
    }

    function getLevelAddress() internal view override returns (address) {
        return 0x9b261b23cE149422DE75907C6ac0C30cEc4e652A;
    }

    function getCreationValue() internal view override returns (uint256) {
        return 0.001 ether;
    }
}
