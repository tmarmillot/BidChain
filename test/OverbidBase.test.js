const { assert } = require('chai');
const chai = require('chai');
const { tokenToString } = require('typescript');
// Import utilities from Test Helpers
const { BN, expectEvent, expectRevert } = require('@openzeppelin/test-helpers');
chai.use(require('chai-as-promised'));
chai.should();

const OverbidFactory = artifacts.require('OverbidBaseFactory');
const BidFactory = artifacts.require('BidFactory');

contract('OverBidContrat contract', async (accounts) => {
    
    const user1 = accounts[1];
    const user2 = accounts[2];

    beforeEach(async () => {
        this.overbid = await OverbidFactory.new();
        this.bidFactory = await BidFactory.new();
      })

    it('should create overbid', async () => {
        await this.bidFactory.deploy("painting");
        const bids = await this.bidFactory.getBids();
        await this.overbid.deploy(10,bids[0],{from: user2});
        const bidModified = await this.bidFactory.getBid(bids[0]);
        assert.equal(bidModified.highestPrice.toNumber(),10);
    });

});