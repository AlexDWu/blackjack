class window.HandView extends Backbone.View
  className: 'hand'

  template: _.template '<h2><% if(isDealer){ %>Dealer<% }else{ %>You<% } %> (<span class="score"></span>)</h2>'

  initialize: ->
    @listenTo(@collection, 'add remove change', => @render())
    @listenTo(@collection, 'bust', => @renderBust())
    @render()

  render: ->
    @$el.children().detach()
    @$el.html @template @collection
    @$el.append @collection.map (card) ->
      new CardView(model: card).$el
    @$('.score').text @collection.scores()[0]

  renderBust: ->
    @render()
    @$el.children('h2').append('<span class="bust">BUST!</span>')
