
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import "ds-test/test.sol";
import { IGatekeeper, GatekeeperSolution} from "src/13_Gatekeeper1/GatekeeperSolution.sol";
import { Gatekeeper } from "src/13_Gatekeeper1/Gatekeeper.sol";
import 'lib/openzeppelin-contracts/contracts/math/SafeMath.sol';

contract GatekeeperTest is DSTest {
    using SafeMath for uint256;

    IGatekeeper gatekeeperProd;
    Gatekeeper gatekeeperNew;
    GatekeeperSolution gatekeeperSolution;

    function setUp() public {
        gatekeeperProd = IGatekeeper(0x9a13d7eE3064697dD3e651aF9f71268Ce0DE8fe6);
        gatekeeperNew = new Gatekeeper();
        gatekeeperSolution = GatekeeperSolution(0x0E206c3213421ED11c1Dd2FDbD76cA494320486a);
    }

    function testFailBreakIn(uint256 seed) public {
        uint256 gasLimit = seed.mod(819100);
        emit log_named_uint("gasLimit", gasLimit);

        uint16 seed = uint16(tx.origin);
        bytes memory encodedSeed = abi.encodePacked(seed);
        emit log_named_bytes("encodedSeed", encodedSeed);
        bytes8 key = bytes8(0x100000000000ea72);
        uint32 check = uint32(uint64(key));

        uint256 gasbefore = gasleft();
        gatekeeperSolution.breakIn(gasLimit, key, gatekeeperProd);
    }

    function testSuccessBreakIn() public {
        uint256 gasLimit = 409804;

        address origin = 0x6f31C2943866bFA792884F6579906BeE388D1C7A;
        uint16 seed = uint16(origin);
        bytes memory encodedSeed = abi.encodePacked(seed);
        emit log_named_bytes("encodedSeed", encodedSeed);
        bytes8 key = bytes8(0x1000000000001c7a);
        uint32 check = uint32(uint64(key));

        gatekeeperSolution.breakIn(gasLimit, key, gatekeeperProd);
    }

}
