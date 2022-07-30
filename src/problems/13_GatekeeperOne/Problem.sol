// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "lib/openzeppelin-contracts/contracts/math/SafeMath.sol";
import "ds-test/test.sol";

// Make it past the gatekeeper and register as an entrant to pass this level.

// Things that might help:
// Remember what you've learned from the Telephone and Token levels.
// You can learn more about the special function gasleft(), in Solidity's documentation (see here and here).
contract Gatekeeper is DSTest {
    using SafeMath for uint256;

    address public entrant;

    modifier gateOne() {
        require(msg.sender != tx.origin);
        _;
    }

    modifier gateTwo() {
        require(gasleft().mod(8191) == 0, "Wrong gasleft");
        _;
    }

    modifier gateThree(bytes8 _gateKey) {
        require(
            uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)),
            "GatekeeperOne: invalid gateThree part one"
        );
        require(
            uint32(uint64(_gateKey)) != uint64(_gateKey),
            "GatekeeperOne: invalid gateThree part two"
        );
        require(
            uint32(uint64(_gateKey)) == uint16(tx.origin),
            "GatekeeperOne: invalid gateThree part three"
        );
        _;
    }

    function enter(bytes8 _gateKey)
        public
        gateOne
        gateTwo
        gateThree(_gateKey)
        returns (bool)
    {
        entrant = tx.origin;
        return true;
    }
}
