// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

interface IPrivacy {
    function unlock(bytes16) external;
}

contract PrivacySolution {

  // bool public locked = true;
  // uint256 public ID = block.timestamp;
  // uint8 private flattening = 10;
  // uint8 private denomination = 255;
  // uint16 private awkwardness = uint16(now);
  // bytes32[3] private data;

  // constructor(bytes32[3] memory _data) public {
  //   data = _data;
  // }
  
  function convert(bytes32 _key) external pure returns(bytes16){
      return(bytes16(_key));
  }

  /*
    A bunch of super advanced solidity algorithms...

      ,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`
      .,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,
      *.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^         ,---/V\
      `*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.    ~|__(o.o)
      ^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'  UU  UU
  */
}
