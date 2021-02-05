// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.0;

contract BidBase  {

    event BidCreated(
        address indexed owner,
        uint bidId,
        string name,
        uint32 creationDate
    );

    struct Bid {
        uint id;
        string name;
        uint32 creationDate;
    }

    Bid[] public bids;

    
    mapping (uint => address) public bidToOwner;
    mapping (address => uint) ownerBidCount;
    
    function _generateRandomId(string memory _str) private pure returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % 10**16;
    }

    function _createBid(string memory _name) internal {
        Bid memory _bid = Bid({
            id: _generateRandomId(_name),
            name: _name,
            creationDate: uint32(block.timestamp)
        });

        bids.push(_bid);
        uint i = bids.length - 1;
        bidToOwner[i] = msg.sender;
        ownerBidCount[msg.sender]++;

        emit BidCreated(msg.sender,_bid.id,_bid.name,_bid.creationDate);
    }

    function createBid(string memory _name) external {
        _createBid(_name);
    }

    function info(uint _id) public view returns (uint id, string memory name, uint32 creationDate){
        return (bids[_id].id,bids[_id].name,bids[_id].creationDate);
    }

    function getBidsByOwner(address _owner) external view returns(uint[] memory) {
        uint[] memory result = new uint[](ownerBidCount[_owner]);
        uint counter = 0;
        for (uint i = 0; i < bids.length; i++) {
            if (bidToOwner[i] == _owner) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }


}