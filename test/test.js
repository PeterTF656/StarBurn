const StarBurn = artifacts.require('./StarBurn.sol')

require('chai')
  .use(require('chai-as-promised'))
  .should()

contract('StarBurn', ([deployer, author, tipper]) => {
  let starBurn

  before(async () => {
    starBurn = await StarBurn.deployed()
  })

  describe('deployment', async () => {
    it('deploys successfully', async () => {
      const address = await starBurn.address
      assert.notEqual(address, 0x0)
      assert.notEqual(address, '')
      assert.notEqual(address, null)
      assert.notEqual(address, undefined)
    })

    it('has a name', async () => {
      const name = await starBurn.name()
      assert.equal(name, 'StarBurn')
    })
  })

  describe('images', async () => {
    let result, imageCount
    const hash = "abc123"

    before(async () => {
      result = await starBurn.uploadImage(hash, "Image description", { from: author})
      imageCount = await starBurn.imageCount()
  })

    it('create images', async () => {
 //success
      assert.equal(imageCount, 1);
      const event = result.logs[0].args;
      assert.equal(event.id.toNumber(), imageCount.toNumber(), 'id is correct')
      assert.equal(event.hash, hash, 'Hash is correct')
      assert.equal(event.description, 'Image description', 'description is correct')
      assert.equal(event.tipAmount, '0', 'tip amount is correct')
      assert.equal(event.author, author, 'author is correct')

            // FAILURE: Image must have hash
      await starBurn.uploadImage('', 'Image description', { from: author }).should.be.rejected;

      // FAILURE: Image must have description
      await starBurn.uploadImage('Image hash', '', { from: author }).should.be.rejected;    
    })
     //list images & check from Struct:
     it('lists images', async () => {
       const image = await starBurn.images(imageCount)
       assert.equal(image.id.toNumber(), imageCount.toNumber(), 'id is correct')
       assert.equal(image.hash, hash, 'Hash is correct')
       assert.equal(image.description, 'Image description', 'description is correct')
       assert.equal(image.tipAmount, '0', 'tip amount is correct')
       assert.equal(image.author, author, 'author is correct')
     })

     it('allows users to tip images', async () => {
        // Track the author balance before purchase
        let oldAuthorBalance
        oldAuthorBalance = await web3.eth.getBalance(author)
        oldAuthorBalance = new web3.utils.BN(oldAuthorBalance)

        result = await starBurn.tipImageOwner(imageCount, { from: tipper, value: web3.utils.toWei('1', 'Ether') })

        // SUCCESS
        const event = result.logs[0].args
        assert.equal(event.id.toNumber(), imageCount.toNumber(), 'id is correct')
        assert.equal(event.hash, hash, 'Hash is correct')
        assert.equal(event.description, 'Image description', 'description is correct')
        assert.equal(event.tipAmount, '1000000000000000000', 'tip amount is correct')
        assert.equal(event.author, author, 'author is correct')

        // Check that author received funds
        let newAuthorBalance
        newAuthorBalance = await web3.eth.getBalance(author)
        newAuthorBalance = new web3.utils.BN(newAuthorBalance)

        let tipImageOwner
        tipImageOwner = web3.utils.toWei('1', 'Ether')
        tipImageOwner = new web3.utils.BN(tipImageOwner)

        const expectedBalance = oldAuthorBalance.add(tipImageOwner)

        assert.equal(newAuthorBalance.toString(), expectedBalance.toString())

        // FAILURE: Tries to tip a image that does not exist
        await starBurn.tipImageOwner(99, { from: tipper, value: web3.utils.toWei('1', 'Ether')}).should.be.rejected;
      })
  })
})