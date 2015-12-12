assert = chai.assert

describe 'App', ->
  app = null
  dealer = null
  player = null
  deck = null
  cards = null

  beforeEach ->
    app = new App()
    player = app.get('playerHand') #this is a hand
    dealer = app.get('dealerHand') #this is a hand
    deck = new Deck()
    cards = []
    for i in [0...13] by 1
      cards.push(new Card(rank: i, suit: 0))

  describe 'playerStandHandler', ->
    it "should only fire if the player's hand is under 21", ->
      app.get('playerHand').stand()
      console.log(app.get('playerHand').minScore())
      assert.isTrue(app.get('playerHand').minScore() <= 21)

  describe 'dealerStandHandler', ->
    it "should only be called when dealer triggers 'stand'", ->
      dealer.trigger('stand')
      expect(app.get('winner')).to.exist
    it "should be able to declare a player a winner", ->
      newPlayer = new Hand([
        cards[1]
        cards[10]
      ], deck, false)
      newDealer = new Hand([
        cards[10]
        cards[8]
      ], deck, true)
      app.set('playerHand', newPlayer)
      app.set('dealerHand', newDealer)
      app.dealerStandHandler()
      expect(app.get('winner')).to.be.equal('Player')
    it "should be able to declare a dealer a winner", ->
      newDealer = new Hand([
        cards[1]
        cards[10]
      ], deck, true)
      newPlayer = new Hand([
        cards[10]
        cards[8]
      ], deck)
      app.set('playerHand', newPlayer)
      app.set('dealerHand', newDealer)
      app.dealerStandHandler()
      expect(app.get('winner')).to.be.equal('Dealer')
    it "should be able to declare a tie", ->
      newPlayer = new Hand([
        cards[8]
        cards[10]
      ], deck, false)
      newDealer = new Hand([
        cards[10]
        cards[8]
      ], deck, true)
      app.set('playerHand', newPlayer)
      app.set('dealerHand', newDealer)
      app.dealerStandHandler()
      expect(app.get('winner')).to.be.equal('No one')

  describe 'dealerBustHandler', ->
    it 'should only be fired when the dealer score is greater than 21'
    

  describe 'playerBustHandler', ->
