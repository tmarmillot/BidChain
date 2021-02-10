// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.0;

import "./OverbidBase.sol";

contract BidBase  {

    string public  name;
    uint32 public creationDate;
    address public owner;
    OverbidBase[] public overbids;
    uint public highestPrice;
    

    constructor(string memory _name,uint32 _creationDate, address _owner){
        name = _name;
        creationDate = _creationDate;
        owner = _owner;
        highestPrice = 0;
    }

    function addOverBid(OverbidBase overbid) public {
        require(highestPrice < overbid.price(), "There already is a higher bid.");
        overbids.push(overbid);
        highestPrice = overbid.price();
    }

    function info() external view returns (string memory _name, uint32 _creationDate, address _owner, uint _highestPrice) {
        return (name, creationDate, owner, highestPrice);
    }

}