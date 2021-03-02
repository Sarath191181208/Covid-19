extends KinematicBody2D
var player =  null 
var move = Vector2.ZERO
var speed = 0.7
const GRAVITY = 20
func _physics_process(delta):
	move = Vector2.ZERO
	move.y = move.y + GRAVITY
	if is_on_floor():
		move.y = 0
	move = move_and_slide(move,Vector2.UP)
	if player != null :

		move.x = position.direction_to(player.position).x * speed
		if move.x > 0 :
			$AnimatedSprite.play("walk")
			$AnimatedSprite.flip_h = false
		elif move.x < 0 :
			$AnimatedSprite.play("walk")
			$AnimatedSprite.flip_h = true
		else :
			$AnimatedSprite.play("idle")
	else :
		move.x = Vector2.ZERO.x
	
	#move = move.normalized()
	move = move_and_collide(move)
	
	
func _on_detecting_range_body_entered(body):
	if body != self :
		player = body



func _on_detecting_range_body_exited(body) :
	player = null
	$AnimatedSprite.play("idle")
