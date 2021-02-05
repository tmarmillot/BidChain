// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.0;

contract OverbidBase {

  event overbidCreated(
    address indexed owner,
    address indexed bid,
    uint256 id,
    uint256 price
  );

  struct Overbid {
      uint256 id;
      uint256 price;
      address bid;
  }

  Overbid[] private overbids;

  mapping (uint => address) public bidToOwner;
  mapping (address => uint) ownerBidCount;

      
  function _generateRandomId(uint _str) private pure returns (uint) {
      uint rand = uint(keccak256(abi.encodePacked(_str)));
      return rand % 10**16;
  }

  function _createOverbid(uint256 _price,address _bid) internal {
    Overbid memory _overbid = Overbid({
      id: _generateRandomId(_price),
      price: _price,
      bid: _bid
    });

    overbids.push(_overbid);
    uint i = overbids.length - 1;

    overbids[i] = _overbid;

    emit overbidCreated(msg.sender,_overbid.bid,_overbid.id,_overbid.price);
  }

  function createOverbid(uint256 _price,address _bid) external {
    _createOverbid(_price, _bid);
  }

  function getOverbidByBid(address _bid) external view returns(uint[] memory) {
        uint[] memory result = new uint[](1);
        uint counter = 0;
        for (uint i = 0; i < overbids.length; i++) {
            if (overbids[i].bid == _bid) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }

  function info(uint _id) public view returns (uint256 id, uint256 price, address bid){
    return (overbids[_id].id,overbids[_id].price,overbids[_id].bid);
  }

}