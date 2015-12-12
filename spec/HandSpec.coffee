assert = chai.assert

describe 'hand',  ->
  deck = null
  hand = null
  ace = null
  cards = null

  beforeEach ->
    deck = new Deck()
    hand = new Hand([], deck, false)
    cards = []
    for i in [0...13] by 1
      cards.push(new Card(rank: i, suit: 0))
    sinon.spy(hand, 'trigger')

  describe 'stand', ->
    it 'should have a `stand` function', ->
      assert.isFunction(hand.stand)

    it 'should trigger stand event', ->
      hand.stand()
      expect(hand.trigger).to.have.been.calledWith('stand')

  describe 'hit', ->
    it 'should add a card from deck', ->
      assert.strictEqual deck.last(), hand.hit()

  describe 'hasAce', ->
    it "should know when an ace is in it's collection", ->
      assert.isFalse(hand.hasAce() is 1)
      hand.add(cards[1])
      assert.isTrue(hand.hasAce() > 0)
