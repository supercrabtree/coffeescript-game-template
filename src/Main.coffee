$ ->
	canvasWidth = $(window).width()
	canvasHeight = $(window).height()
	frameRate = 1000/25
	new Main canvasWidth, canvasHeight, frameRate

class Main extends AppBase
	constructor: (w, h, fps) ->
		super w, h, fps
		@renderList
		# make things here
		@startGameLoop()

	update: (modifier) ->
		# do stuff with the stuff you made here

	render: ->
		# after you've done stuff with your stuff, render it
		@clearCanvas()
		@renderList.sort (a, b) -> (parseFloat a.position.y) - (parseFloat b.position.y) # sort the list on its y values
		for item in @renderObjects
			item.render @context


