class window.Player extends Backbone.Model

  defaults:
    deck: null
    activeHand: null # active hand
    hands: [] # list of hands
    playedHands: [] # list of hands

  initialize: (hand) ->
    @set 'activeHand', hand

  hit: ->
    # call hit on activeHand
    @get('activeHand').hit() #returns a card

  stand: ->
    # call stand on activeHand
    @get('activeHand').stand() #triggers event 'stand'
    # swap hands
    _swapHands => @trigger('stand')

  split: ->
    if (@get('activeHand').status == 'splittable')
      # by taking out card from current hand
      detachedCard = @get('activeHand').pop()
    # create new hand
    # push into hands
      @get('hands').push(new Hand([detachedCard], @get('deck'), false))

  handleBust: ->
    # swap hands
    @_swapHands () =>
      busted = _.all(@get('playedHands'), (hand) =>
        true if hand.status == 'busted'
      )
      if busted 
        @trigger('bust')
      else
        @trigger('stand')

  _swapHands: (cb) ->
    if (@get('hands').length > 0)
    # push activeHand into played hands
      @get('playedHands').push(@get('activeHand'))
    # pop off first Hand from @hands into activeHand
      @set('activeHand', @get('hands').pop())
    else
      cb()

    @trigger('swapHands')



  
  