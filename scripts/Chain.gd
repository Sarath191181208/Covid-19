extends Node2D

onready var links = $Tip/Links		# A slightly easier reference to the links
var direction := Vector2(0,0)	# The direction in which the chain was shot
var tip := Vector2(0,0)			# The global position the tip should be in
								# We use an extra var for this, because the chain is 
								# connected to the player and thus all .position
								# properties would get messed with when the player
								# moves.
export (int) var maximimLength = 1300
var SPEED = 5	# The speed with which the chain moves
var alreadySgaked = false
var flying = false	# Whether the chain is moving through the air
var hooked = false	# Whether the chain has connected to a wall

# shoot() shoots the chain in a given direction
func shoot(dir: Vector2) -> void:
	direction = dir.normalized()	# Normalize the direction and save it
	flying = true					# Keep track of our current scan
	tip = self.global_position		# reset the tip position to the player's position

# release() the chain
func release() -> void:
	flying = false	# Not flying anymore	
	hooked = false	# Not attached anymore

# Every graphics frame we update the visualsl
func _process(_delta: float) -> void:
	self.visible = flying or hooked	# Only visible if flying or attached to something
	if not self.visible:
		return	# Not visible -> nothing to draw
	var tip_loc = to_local(tip)	# Easier to work in local coordinates
	# We rotate the links (= chain) and the tip to fit on the line between self.position (= origin = player.position) and the tip
	$Tip.rotation = direction.angle() + PI/2
	if SPEED != 0:
		links.region_rect.size.y = tip_loc.length()
	links.offset.y = links.region_rect.size.y/2  - 120
# Every physics frame we update the tip position
func _physics_process(_delta: float) -> void:
	if to_local(tip).length() > maximimLength:
		links.region_rect.size.y -=30
		if links.region_rect.size.y <= 0:
			var player = get_parent().get_node("player")
			player.chain_shot = false
			queue_free()
		SPEED = 0

	if hooked == true and alreadySgaked == false:
		var player = get_parent().get_node("player")
		player.camera.shake()
		player.camera.y = 0
		alreadySgaked = true
	$Tip.global_position = tip	# The player might have moved and thus updated the position of the tip -> reset it
	if flying:
		# `if move_and_collide()` always moves, but returns true if we did collide
		if $Tip.move_and_collide(direction * SPEED):
			hooked = true	# Got something!
			flying = false	# Not flying anymore
	tip = $Tip.global_position	# set `tip` as starting position for next frame

		
