pragma solidity >= 0.5.5;
import { IEthernaut } from "./IEthernaut.sol";
import { ILevel } from "./ILevel.sol";

library EthernautLibrary {
    IEthernaut constant ethernaut= IEthernaut(0xD991431D8b033ddCb84dAD257f4821E9d5b38C33);

    function createLevelInstance(address _level, uint256 _value) external {
        ethernaut.createLevelInstance{value: _value}(_level);
    }

    function getLevelAddress(address _level, uint256 _value) external returns(address){
        return ILevel(_level).createInstance{value: _value}(_level);
    }

    function validateInstance(address _level, address payable _instance, address _player) external returns (bool) {
        return ILevel(_level).validateInstance(_instance, _player);
    }

    function submitLevelInstance(address _instance) external {
        ethernaut.submitLevelInstance(_instance);
    }

}
