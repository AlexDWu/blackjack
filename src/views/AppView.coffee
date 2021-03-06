class window.AppView extends Backbone.View
  template: _.template '
    <button class="hit-button">Hit</button> <button class="stand-button">Stand</button>
    <div class="player-hand-container"></div>
    <div class="dealer-hand-container"></div>
  '

  events:
    'click .hit-button': -> @model.get('playerHand').hit()
    'click .stand-button': -> @model.get('playerHand').stand()

  initialize: ->
    @listenTo(@model, 'change:winner', @handleWinner)
    @render()

  render: ->
    @$el.children().detach()
    @$el.html @template()
    @$('.player-hand-container').html new HandView(collection: @model.get 'playerHand').el
    @$('.dealer-hand-container').html new HandView(collection: @model.get 'dealerHand').el

  handleWinner: (winnerName) ->
    @$el.children().detach()
    @$el.text("#{@model.get('winner')} is the winner!")
    @$el.append(new HandView(collection: @model.get 'playerHand').el)
    @$el.append(new HandView(collection: @model.get 'dealerHand').el)

  disableHit: ->

  disableStand: ->

