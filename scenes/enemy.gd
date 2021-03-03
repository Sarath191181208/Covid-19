extends KinematicBody2D
var player =  null 
var move = Vector2.ZERO
var speed = 0.7
var direction = -1
const GRAVITY = 20
const LOOT = preload("res://scenes/coin.tscn")

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
	
	
	if not $floor_checker.is_colliding():
		move.x = 0
		if player != null :
			$AnimatedSprite.play("idle")
	move = move_and_collide(move)
func _on_detecting_range_body_entered(body):
	if body != self :
		player = body

func got_shot():
	if player != null :
		player = null
	$AnimatedSprite.play("dead")
	$timer.connect("timeout", self, "queue_free")
	$timer.set_wait_time(2)
	$timer.start()
	$timer2.connect("timeout", self, "createLoot")
	$timer2.set_wait_time(2.2)
	$timer2.start()
	var loot = LOOT.instance()
	get_parent().add_child(loot)
	loot.position = $Position2D.global_position
func createLoot():
	print("sucess ")

func _on_detecting_range_body_exited(body) :
	player = null
	$AnimatedSprite.play("idle")

