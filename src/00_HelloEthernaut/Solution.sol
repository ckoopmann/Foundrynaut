pragma solidity ^0.6.0;

contract ForceSolution {

    function sendIt(address payable receiver) external payable {
        // Selfdestruct sends ether to receiver
        // Had to look this one up: https://medium.com/@alexsherbuck/two-ways-to-force-ether-into-a-contract-1543c1311c56
        selfdestruct(receiver);
    }

}

