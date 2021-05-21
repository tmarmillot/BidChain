// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.0;

contract BidV2  {

    struct Bid {
      string name;
      uint256 creationDate;
      address owner;
    }

    struct Overbid {
      uint price;
      address owner;
    }

    mapping(bytes32 => Bid) public bids;
    mapping(bytes32 => Overbid[]) public overbids;
    mapping(bytes32 => uint) public highestPrice;


    event BidCreated(bytes32 bidId);
    event BidAdded(bytes32 bidId, uint price);

    /*
     * Compute a unique identifier for this bid. The identifier is just a keccak256 hash of (name, owner)
     */
    function computeBidId(string memory _name, address _owner) pure public returns(bytes32) {
      return keccak256(abi.encodePacked(_name, _owner));
    }

    /*
     * Store a new bid in the Contract
     * Revert if this bid already exists
     */
    function createBid(string memory _name) public {
      bytes32 bidId = computeBidId(_name, msg.sender);
      
      // Check that this bid is not already registered
      require(bids[bidId].owner == address(0), "This bid already exists");
      
      // Store the new bid in the mapping
      bids[bidId] = Bid ({
        name: _name,
        creationDate: block.timestamp,
        owner: msg.sender
      });

      emit BidCreated(bidId);
    }

    /*
     * Add a new Overbid
     * Revert if _bidId does not exists or another Overbid exists with higher price
     */
    function addOverbid(bytes32 _bidId, uint _price) public {
      require(bids[_bidId].owner != address(0), "This bid does not exists");
      require(highestPrice[_bidId] < _price, "Another higher price Overbid exists");

      overbids[_bidId].push(Overbid({
        price: _price,
        owner: msg.sender
      }));

      highestPrice[_bidId] = _price;

      emit BidAdded(_bidId, _price);
    }

}