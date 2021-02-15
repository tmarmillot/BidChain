// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.0;

import "./BidBase.sol";

contract OverbidBase {

    uint public price;
    BidBase bid;
    address owner;

    constructor (uint _price, BidBase _bid, address _owner){
      price = _price;
      bid = _bid;
      owner = _owner;
    }

}