class window.Hand extends Backbone.Collection
  model: Card

  initialize: (array, @deck, @isDealer) ->

  hit: ->
    @add(@deck.pop())
    @last()

  stand: ->
    @trigger('stand')

  # this is a dealer only method
  play: ->
    # flip hole card
    # check the score
    @hit() while Math.max(@scores()) < 17

    #if max is less than or equal to 21 stand
    if(Math.max(@scores()) <= 21)
      @trigger('stand')
      return

    @hit() while Math.min(@scores()) < 17
      
    # if math is less than or equal to 21 stand
    if(Math.min(@scores()) <= 21)
      @trigger('stand')
    else
      @trigger('bust')


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


