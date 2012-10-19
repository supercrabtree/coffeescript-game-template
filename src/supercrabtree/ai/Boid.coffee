class Boid
	constructor: (x=0, y=0) ->
		@maxSpeed = 10
		@maxForce = 5
		@velocity = new Vector
		@lastPosition = new Vector
		@acceleration = new Vector
		@position = new Vector x, y
		@wanderAngle = 0
		@wanderRadius = 10
		@wanderChange = 1
		@wanderLength = 2.5
		@boundsRadius = 200
		@boundsCentre = new Vector window.CANVAS_WIDTH, window.CANVAS_HEIGHT
		@radius = 200

	update: ->
    	@lastPosition.copy @position
    	@velocity.add @acceleration
    	@velocity.truncate @maxSpeed
    	@position.add @velocity
    	@acceleration.zero()
    	@checkForEdges()
	
	applyForce: (force) ->
		@acceleration.add force

	wander: ->
		circleMiddle = @velocity.clone()
		circleMiddle.norm()
		circleMiddle.multiply @wanderRadius
		wanderForce = new Vector
		wanderForce.setLength @wanderLength
		wanderForce.setAngle @wanderAngle
		@wanderAngle += Math.random() * @wanderChange - @wanderChange * .5
		circleMiddle.add wanderForce
		@applyForce wanderForce

	arrive: (target, slowingDistance=20) ->
		desired = Vector.subtract target, @position
		distance = desired.length()
		if distance > slowingDistance then @seek target
		else
			desired.norm()
			desired.multiply @maxSpeed * distance/slowingDistance
			steer = Vector.subtract desired, @velocity
			steer.truncate @maxForce
			@applyForce steer

	seek: (target) ->
		desired = Vector.subtract target, @position
		desired.norm();
		desired.multiply @maxSpeed
		steer = Vector.subtract desired, @velocity
		steer.truncate @maxForce
		@applyForce steer

	flee: (target, threshold=50) ->
		if (@position.distance target) > threshold
			@velocity.zero()
		else
			desired = Vector.subtract target, @position
			desired.norm();
			desired.multiply @maxSpeed
			desired.multiply -1
			steer = Vector.subtract desired, @velocity
			steer.truncate @maxForce
			@applyForce steer

	checkForEdges: ->
		if @position.equals @lastPosition then return

		# bounce off the edges, gets trapped sometimes, needs fixing
		if (0 < @position.x < window.CANVAS_WIDTH) is false then @velocity.x = -@velocity.x
		if (0 < @position.y < window.CANVAS_HEIGHT) is false then @velocity.y = -@velocity.y

		# distance = Vector.distance @position, @boundsCentre

		# if distance > @boundsRadius + @radius
		# 	@position.subtract @boundsCentre
		# 	@position.normalize()
		# 	@position.scaleBy @boundsRadius + @radius
		# 	@velocity.multiply -1
		# 	@position.add @velocity
		# 	@position.add @boundsCentre
						
							
	isCollidingWith: (vector, threshold=10) ->
		if (Vector.subtract @position, vector).length() < threshold then true else false

	persuit: (target) ->
		# meh
		distance = @position.distance target
		t = distance / @maxSpeed
		v = @velocity.clone()
		p = @position.clone()
		v.multiply t
		p.add v
		@seek p

	evade: (target, threshold=50) ->
		#meh
		distance = @position.distance target
		t = distance / @maxSpeed
		v = @velocity.clone()
		p = @position.clone()
		v.multiply t
		p.add v




