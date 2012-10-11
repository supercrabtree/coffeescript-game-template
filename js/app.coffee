$ ->
	new Main 800, 600

class window.Main
	constructor: (@CANVAS_WIDTH, @CANVAS_HEIGHT) ->
		@ctx
		do @buildCanvas
		do @startGame

	startGame: ->
		@gameLoopInterval = setInterval @gameLoop, 1

	stopGame: ->
		clearInterval @gameLoopInterval

	update: (modifier) ->

	render: ->
		@ctx.clearRect 0, 0, @CANVAS_WIDTH, @CANVAS_HEIGHT

	gameLoop: =>
		now = do Date.now
		delta = now - @before
		@update delta / 1000
		do @render
		@before = now

	buildCanvas: ->
		canvas = document.createElement "canvas"
		@ctx = canvas.getContext "2d"
		canvas.width = @WIDTH
		canvas.height = @HEIGHT
		document.body.appendChild canvas