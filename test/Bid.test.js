const { assert } = require('chai');
const chai = require('chai');
const { tokenToString } = require('typescript');
// Import utilities from Test Helpers
const { BN, expectEvent, expectRevert } = require('@openzeppelin/test-helpers');
chai.use(require('chai-as-promised'));
chai.should();

const Bid = artifacts.require('BidBase');

contract('Bid contract', async (accounts) => {

    const user1 = accounts[1];

    beforeEach(async function () {
        this.bid = await Bid.new();
      })

    it('should create bid', async function () {
        await this.bid.createBid("painting",{from: user1});
        let bids = await this.bid.getBidsByOwner(user1);
        let bid = await this.bid.info(bids[0]);
        assert.equal(bid.name,"painting");
    });

});