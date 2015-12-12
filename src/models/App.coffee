# TODO: Refactor this model to use an internal Game Model instead
# of containing the game logic directly.
class window.App extends Backbone.Model
  initialize: ->
    @set 'deck', deck = new Deck()
    @set 'playerHand', deck.dealPlayer()
    @set 'dealerHand', deck.dealDealer()
    # listening to game collection
    # listenTo takes model, event, cb
    @listenTo (@get 'playerHand'), 'stand', @playerStandHandler
    @listenTo (@get 'playerHand'), 'bust', @playerBustHandler
    @listenTo (@get 'dealerHand'), 'stand', @dealerStandHandler
    @listenTo (@get 'dealerHand'), 'bust', @dealerBustHandler

  playerStandHandler: ->
    # tell dealer to play (beat 17)
    @get('dealerHand').play()

  dealerStandHandler: ->
    # check score
    playerScore = @get('playerHand').scores();
    dealerScore = @get('dealerHand').scores();

    playerScore = if playerScore[1] > 21 then playerScore[0] else playerScore[1]
    dealerScore = if dealerScore[1] > 21 then dealerScore[0] else dealerScore[1]
    
    if playerScore > dealerScore 
        @set('winner', 'Player') 
    else if playerScore < dealerScore 
        @set('winner', 'Dealer')
    else
        @set('winner', 'No one')
    
  playerBustHandler: ->
    # player loses
    @set('winner', 'Dealer')

  dealerBustHandler: ->
    # plaer wins
    @set('winner', 'Player')