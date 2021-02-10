const { assert } = require('chai');
const chai = require('chai');
const { tokenToString } = require('typescript');
// Import utilities from Test Helpers
const { BN, expectEvent, expectRevert } = require('@openzeppelin/test-helpers');
chai.use(require('chai-as-promised'));
chai.should();

const OverbidFactory = artifacts.require('OverbidBaseFactory');

contract('OverBidContrat contract', async (accounts) => {
    
    const user1 = accounts[1];
    const user2 = accounts[2];

    before(async function (){
        this.BidFactory = await ethers.getContractFactory("BidFactory");
    })

    beforeEach(async function () {
        this.overbid = await OverbidFactory.new();
        this.bidFactory = await this.BidFactory.deploy();
        await this.bidFactory.deployed();
      })

    it('should create overbid', async function () {
        await this.bidFactory.deploy("painting");
        await this.bidFactory.deployed();
        let bids = await this.bidFactory.getBids();
        await this.overbid.deploy(10,bids[0],{from: user2});
        let bidModified = await this.bidFactory.getBid(bids[0]);
        assert.equal(bidModified.highestPrice.toNumber(),10);
    });

});