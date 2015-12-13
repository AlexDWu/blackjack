assert = chai.assert

describe 'hand',  ->
  deck = null
  hand = null
  ace = null
  cards = null

  beforeEach ->
    deck = new Deck()
    cards = []
    for i in [0...13] by 1
      cards.push(new Card(rank: i, suit: 0))
    hand = new Hand([], deck, false)
    sinon.spy(hand, 'trigger')

  afterEach ->
    hand.trigger.restore()

  describe 'initialize', ->
    it 'should initialize with the status of playable', ->
      hand = new Hand([cards[4], cards[5]], deck, false)
      expect(hand.status).to.equal('playable')
      
    it "it should set it's status to splittable if both cards are the same rank", ->
      hand = new Hand([cards[4], cards[4]], deck, false)
      expect(hand.status).to.equal('splittable')
      expect(hand.trigger).to.have.been.calledWith('splittable')

  describe 'stand', ->
    it 'should have a `stand` function', ->
      assert.isFunction(hand.stand)

    it 'should trigger stand event', ->
      hand.stand()
      expect(hand.trigger).to.have.been.calledWith('stand')

  describe 'hit', ->
    it 'should add a card from deck', ->
      assert.strictEqual deck.last(), hand.hit()
    it 'should check for a bust', ->
      hand.add(cards[0]);
      hand.add(cards[10]);
      expect(hand.trigger).to.not.have.been.calledWith('bust')
      hand.hit();
      expect(hand.trigger).to.have.been.calledWith('bust')

  describe 'hasAce', ->
    it "should know when an ace is in it's collection", ->
      assert.isFalse(hand.hasAce() is 1)
      hand.add(cards[1])
      assert.isTrue(hand.hasAce() > 0)
  
  describe 'minScore', ->
    it "should return the lowest score in a set of cards with an Ace", ->
      hand.add(cards[1])
      hand.add(cards[9])
      expect(hand.minScore()).to.equal(10)

  describe 'scores', ->
    it 'should have the same scores if there is not Ace', ->
      hand.add(cards[4])
      hand.add(cards[9])
      expect(hand.scores()[0]).to.equal(13)
      expect(hand.scores()[1]).to.equal(13)
    it 'should have different scores if there is an Ace', ->
      hand.add(cards[1])
      hand.add(cards[0])
      expect(hand.scores()[0]).to.equal(11)
      expect(hand.scores()[1]).to.equal(21)

  describe 'play', ->
    beforeEach ->
      sinon.spy(hand, 'hit')

    afterEach ->
      hand.hit.restore()

    it "should reveal first card if it's hidden", ->
      hand.add(cards[1].flip())
      hand.add(cards[11])
      expect(cards[1].get('revealed')).to.be.false
      hand.play()
      expect(cards[1].get('revealed')).to.be.true
      hand.play()
      expect(cards[1].get('revealed')).to.be.true
    it "should do nothing when it's a bust", ->
      hand.add(cards[1]) # add and ace
      hand.add(cards[11]) # add a jack
      hand.add(cards[12]) # add a queen
      hand.add(cards[2]) # add a two
      hand.play()
      expect(hand.hit).to.not.have.been.called
    it "should trigger 'stand' when a score is 'greater' 17", ->
      hand.add(cards[12]) #add a queen
      hand.add(cards[8])  #add an eight
      hand.play()
      expect(hand.trigger).to.have.been.calledWith('stand')
      expect(hand.hit).to.not.have.been.called
    it "should trigger 'stand' on a hard 17", ->
      hand.add(cards[1])  #add an Ace
      hand.add(cards[10]) #add a ten
      hand.add(cards[6])  #add a six
      hand.play()
      expect(hand.trigger).to.have.been.calledWith('stand')
      expect(hand.hit).to.not.have.been.called
    it "should hit on a soft 17", ->
      hand.add(cards[1]) #add Ace
      hand.add(cards[6]) #add 6
      hand.play()
      expect(hand.hit).to.have.been.called
      expect(hand.trigger).to.have.been.called

























