class window.Hand extends Backbone.Collection
  model: Card

  status: null
  score: null
  bet: null

  initialize: (array, @deck, @isDealer) ->
    @status = "playable" #can be: `busted`, `stand`, `splittable` 
    if (@first and @last() and @last().get('rankName') == @first().get('rankName'))
      @status = "splittable"
      @trigger('splittable')

  hit: ->
    @add(@deck.pop())
    @checkBust()
    @last()

  stand: ->
    @status = 'stand'
    playerScore = @scores()
    playerScore = if playerScore[1] > 21 then playerScore[0] else playerScore[1]
    @score = playerScore
    @trigger('stand')

  checkBust: ->
    if (_.min(@scores()) > 21)
      @status = 'busted'
      @score = @scores()[1]
      @trigger('bust')

  # this is a dealer only method
  play: ->
    if not(@first().get('revealed'))
      @first().flip()
    if(_.min(@scores()) > 21)
      return
    if(_.max(@scores()) > 17 or _.min(@scores()) >= 17)
      @status = 'stand'
      @trigger('stand')
      return
    @hit()
    @play()

  hasAce: -> @reduce (memo, card) ->
    memo or card.get('value') is 1
  , 0

  minScore: -> @reduce (score, card) ->
    score + if card.get 'revealed' then card.get 'value' else 0
  , 0

  scores: ->
    # The scores are an array of potential scores.
    # Usually, that array contains one element. That is the only score.
    # when there is an ace, it offers you two scores - the original score, and score + 10.
    [@minScore(), @minScore() + 10 * @hasAce()]


