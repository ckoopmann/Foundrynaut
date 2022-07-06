// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import 'lib/openzeppelin-contracts/contracts/math/SafeMath.sol';
import "ds-test/test.sol";

contract Gatekeeper is DSTest {

  address public entrant;

  modifier gateOne() {
    require(msg.sender != tx.origin);
    _;
  }

  modifier gateTwo() {
    uint x;
    assembly { x := extcodesize(caller()) }
    require(x == 0);
    _;
  }

  modifier gateThree(bytes8 _gateKey) {
    uint64 leftHand = uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ uint64(_gateKey);
    uint64 rightHand = uint64(0) - 1;
    emit log_named_uint("leftHand", leftHand);
    emit log_named_uint("rightHand", rightHand);
    require(leftHand == rightHand, "failed gate three");
    _;
  }

  function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
    entrant = tx.origin;
    return true;
  }
}
