assert = chai.assert

describe 'App', ->
	app = null

	beforeEach ->
		app = new App()

	describe 'playerStandHandler', ->
		it "should only fire if the player's hand is under 21", ->
			app.get('playerHand').stand()
			console.log(app.get('playerHand').minScore())
			assert.isTrue(app.get('playerHand').minScore() <= 21)

	describe 'dealerStandHandler', ->
				

	describe 'dealerBustHandler', ->
		it 'should only be fired when the dealer score is greater than 21'
		

	describe 'playerBustHandler', ->
