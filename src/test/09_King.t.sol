
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import "ds-test/test.sol";
import { IKing, KingSolution} from "src/09_King/KingSolution.sol";
import {  King } from "src/09_King/King.sol";

contract ContractTest is DSTest {
    King king;
    KingSolution kingSolution;

    function setUp() public {
        king = King(0xaE04e55c97764EA7f299c356f6eF6Cb442A7B5E8);
        kingSolution = new KingSolution();
    }

    function testKingBefore() public {
        uint currentPrize = king.prize();
        emit log_named_uint("currentPrize", currentPrize);
        uint newPrize = currentPrize + 1;
        (bool success,) = address(king).call{value: king.prize() + 1}("");
        assertTrue(success);
        assertEq(king.prize(), newPrize);
    }

    function testKing() public {
        uint currentPrize = king.prize();
        kingSolution.breakIt{value: currentPrize+1}(IKing(address(king)));
        assertEq(address(kingSolution), king._king());
        (bool success,) = address(king).call{value: king.prize() + 1}("");
        assertTrue(!success);
    }

    receive() external payable {
        emit log_named_uint("Received prize", msg.value);
    }
    fallback() external payable {
        emit log_named_uint("Received prize", msg.value);
    }
}
