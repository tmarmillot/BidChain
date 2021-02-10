const { assert } = require('chai');
const chai = require('chai');
const { tokenToString } = require('typescript');
// Import utilities from Test Helpers
const { BN, expectEvent, expectRevert } = require('@openzeppelin/test-helpers');
chai.use(require('chai-as-promised'));
chai.should();

const BidFactory = artifacts.require('BidFactory');

contract('Bid contract', async (accounts) => {

    const user1 = accounts[1];

    beforeEach(async function () {
        this.bidFactory = await BidFactory.new();
      })

    it('should create bid', async function () {
        await this.bidFactory.deploy("painting",{from: user1});
        let bids = await this.bidFactory.getBids();
        let bid = await this.bidFactory.getBid(bids[0]);

        console.log(new Date(bid.creationDate.toNumber() * 1000).toUTCString());
        assert.equal(bids.length, 1);
    });

});