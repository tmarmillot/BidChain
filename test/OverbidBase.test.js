const { assert } = require('chai');
const chai = require('chai');
const { tokenToString } = require('typescript');
// Import utilities from Test Helpers
const { BN, expectEvent, expectRevert } = require('@openzeppelin/test-helpers');
chai.use(require('chai-as-promised'));
chai.should();

const Overbid = artifacts.require('OverbidBase');

contract('OverBidContrat contract', async (accounts) => {

    before(async function (){
        this.Bid = await ethers.getContractFactory("BidBase");
    })
    
    const user1 = accounts[1];

    beforeEach(async function () {
        this.overbid = await Overbid.new();
        this.bid = await this.Bid.deploy();
        await this.bid.deployed();
      })

    it('should create overbid', async function () {
        await this.bid.createBid("painting");
        await this.overbid.createOverbid(10,this.bid.address,{from: user1});
        let overbids = await this.overbid.getOverbidByBid(this.bid.address);
        let overbid = await this.overbid.info(overbids[0]);
        assert.equal(overbid.bid == this.bid.address)
    });

});