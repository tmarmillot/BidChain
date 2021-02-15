// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.0;

import "./BidBase.sol";

contract BidFactory {

    BidBase[] public bidsAdresses;

    mapping (uint => address) public bidToOwner;
    mapping (address => uint) ownerBidCount;

    event BidCreated(BidBase bid);

    function _createBid(string memory _name) internal {
        BidBase _bid = new BidBase(_name, uint32(block.timestamp), msg.sender);

        bidsAdresses.push(_bid);
        uint i = bidsAdresses.length - 1;
        bidToOwner[i] = msg.sender;
        ownerBidCount[msg.sender]++;

        emit BidCreated(_bid);
    }

    function deploy(string memory _name) external {
        _createBid(_name);
    }

    function getBids() external view returns (BidBase[] memory) {
        return bidsAdresses;
    }

    function getBid(address bidAddress) external view returns (string memory name, uint32 creationDate, address owner,uint highestPrice){
        for(uint i = 0; i < bidsAdresses.length; i++){
            if(address(bidsAdresses[i]) == bidAddress) {
                return bidsAdresses[i].info();
            }
        }
        // throw error if not found.
    }

}
