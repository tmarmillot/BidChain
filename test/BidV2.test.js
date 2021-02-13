const { expect } = require('chai');

describe('BidV2 contract', async () => {
    
    let BidV2;
    let bid;

    beforeEach(async () => {
      BidV2 = await ethers.getContractFactory('BidV2');
      bid = await BidV2.deploy();
      await bid.deployed();
    })
    
    it('should create a new bid', async () => {
      const [user] = await ethers.getSigners();
      
      const id = await bid.computeBidId('TEST', user.address);
      expect(id).to.be.not.null;
      
      await expect(
        bid.connect(user).createBid('TEST')
      ).to.emit(bid, 'BidCreated').withArgs(id);
      
      const { name, creationDate, owner } = await bid.bids(id);
      expect(name).to.be.equal('TEST');
      expect(creationDate.toNumber()).to.be.greaterThan(0);
      expect(owner).to.be.equal(user.address);
    });

    it('should not allow two bid with same name for same user', async () => {
      const [user] = await ethers.getSigners();
      await bid.connect(user).createBid('TEST');

      await expect(
        bid.connect(user).createBid('TEST')
      ).to.be.revertedWith('This bid already exists');
    });

    it('should allow an user to add an overbid', async () => {
      const [user1, user2] = await ethers.getSigners();

      const id = await bid.computeBidId('TEST', user1.address);
      await bid.connect(user1).createBid('TEST');

      expect(await bid.highestPrice(id)).to.be.equal(0);

      await expect(
        bid.connect(user2).addOverbid(id, 100)
      ).to.emit(bid, 'BidAdded').withArgs(id, 100);

      const latestOverbid = await bid.overbids(id, 0);
      expect(latestOverbid.price.toNumber()).to.be.equal(100);
      expect(latestOverbid.owner).to.be.equal(user2.address);
    });

    it('should allow an user to add an overbid on a non existing bid', async () => {
      const [user] = await ethers.getSigners();

      const id = await bid.computeBidId('TEST', user.address);
      
      await expect(
        bid.connect(user).addOverbid(id, 100)
      ).to.be.revertedWith('This bid does not exists');
    });

    it('should revert underpriced Overbid', async () => {
      const [user] = await ethers.getSigners();

      const id = await bid.computeBidId('TEST', user.address);
      await bid.connect(user).createBid('TEST');

      bid.connect(user).addOverbid(id, 100);
      
      await expect(
        bid.connect(user).addOverbid(id, 10)
      ).to.be.revertedWith('Another higher price Overbid exists');
    });

    it('compute cost of creating bid and bidding', async () => {
      const [user] = await ethers.getSigners();
      
      const id = await bid.computeBidId('TEST', user.address);

      const createBidTx = await bid.connect(user).createBid('TEST');
      const { gasUsed: createBidGas } = await createBidTx.wait();
      
      const createOverbidTx = await bid.connect(user).addOverbid(id, 100);
      const { gasUsed: createOverbidGas } = await createOverbidTx.wait();

      const totalGasCost = createBidGas.add(createOverbidGas);

      console.log(`BidV2: Total cost of creating bid & adding an overbid: ${totalGasCost.toNumber()} gas`);
    });
});