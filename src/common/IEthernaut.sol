pragma solidity >= 0.5.5;

interface IEthernaut {
    event LevelCompletedLog(address indexed player, address level);
    event LevelInstanceCreatedLog(address indexed player, address instance);
    event OwnershipTransferred(
        address indexed previousOwner, address indexed newOwner
    );

    function createLevelInstance(address _level) external payable;
    function isOwner() external view returns (bool);
    function owner() external view returns (address);
    function registerLevel(address _level) external;
    function renounceOwnership() external;
    function submitLevelInstance(address _instance) external;
    function transferOwnership(address newOwner) external;
}
