extends KinematicBody2D
var player =  null 
var move = Vector2.ZERO
var speed = 0.7
var direction = -1
var set = true
const GRAVITY = 20

# warning-ignore:unused_argument
func _physics_process(delta):
	$floor_checker.position.x = $CollisionShape2D.shape.get_extents().x * direction
	move = Vector2.ZERO
	move.y = move.y + GRAVITY
	if is_on_floor():
		move.y = 0

	move = move_and_slide(move,Vector2.UP)
	
	if player != null :
		move.x = position.direction_to(player.position).x * speed
		if move.x > 0 :
			direction = 1
			$AnimatedSprite.play("walk")
			$AnimatedSprite.flip_h = false
		elif move.x < 0 :
			direction = -1
			$AnimatedSprite.play("walk")
			$AnimatedSprite.flip_h = true
		else :
			$AnimatedSprite.play("idle")
	else :
		move.x = Vector2.ZERO.x
	
	move = move_and_collide(move)
	if not $floor_checker.is_colliding():
		if player != null :
			player = null
		direction = - direction
		$floor_checker.position.x = $CollisionShape2D.shape.get_extents().x * direction
		$AnimatedSprite.play("idle")
		
func _on_detecting_range_body_entered(body):
	if body != self :
		player = body


# warning-ignore:unused_argument
func _on_detecting_range_body_exited(body) :
	player = null
	$AnimatedSprite.play("idle")
