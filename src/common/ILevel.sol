pragma solidity >= 0.5.5;

interface ILevel {
    function createInstance(address _player)
        external
        payable
        returns (address);
    function validateInstance(address payable _instance, address _player)
        external
        returns (bool);
}
