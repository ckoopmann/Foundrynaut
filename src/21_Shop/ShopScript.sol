// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import "forge-std/Script.sol";
import { IShop } from "src/21_Shop/IShop.sol";
import { ShopSolution } from "src/21_Shop/ShopSolution.sol";

contract ShopScript is Script {

    IShop shop;
    ShopSolution shopSolution;
    address instanceAddress = 0x0EbB62A562c2D65852a660C0E3b1d8BBffE4e559;


    function setUp() public {
        shop = IShop(instanceAddress);
    }

    function run() public {
        vm.startBroadcast();

        shopSolution = new ShopSolution(shop);
        shopSolution.buy();

        assert(shop.isSold());
        assert(shop.price() == 0);

        vm.stopBroadcast();
    }
}
