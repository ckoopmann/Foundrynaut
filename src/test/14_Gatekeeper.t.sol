
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import "ds-test/test.sol";
import { IGatekeeper, GatekeeperSolution} from "src/14_Gatekeeper_2/GatekeeperSolution.sol";
import { Gatekeeper } from "src/14_Gatekeeper_2/Gatekeeper.sol";
import 'lib/openzeppelin-contracts/contracts/math/SafeMath.sol';

contract GatekeeperTest is DSTest {
    using SafeMath for uint256;

    IGatekeeper gatekeeperProd;
    Gatekeeper gatekeeperNew;
    GatekeeperSolution gatekeeperSolution;

    function setUp() public {
        gatekeeperProd = IGatekeeper(0xEdf4e868956fA0bD7cABbE4787cF079219A538F2);
        gatekeeperNew = new Gatekeeper();
    }

    function testConstructorBreakIn() public {
        gatekeeperSolution = new GatekeeperSolution(address(gatekeeperProd));
    }

}
