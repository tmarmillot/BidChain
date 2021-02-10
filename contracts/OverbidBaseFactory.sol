// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.0;

import "./BidBase.sol";

contract OverbidBaseFactory {

    uint price;
    BidBase bid;
    address owner;

    function _createOverbid(uint _price, BidBase _bid) internal {
        require(_price > 0, "Price must be greater than 0");
        OverbidBase overbid = new OverbidBase(_price, _bid, msg.sender);
        _bid.addOverBid(overbid);
    }

    function deploy(uint _price, BidBase _bid) external {
        _createOverbid(_price,_bid);
    }

}