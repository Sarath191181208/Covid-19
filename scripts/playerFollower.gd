extends KinematicBody2D

export var experience = 20
export var damage = 10
export var speed = 1.3
var move = Vector2.ZERO
var colliding_player = null
var is_colliding = false
var player = null
var gotShot = false
var LOOT = preload("res://scenes/coin.tscn")
# warning-ignore:unused_argument
func _physics_process(delta):
	move = Vector2.ZERO
	if player != null :
		move = position.direction_to(player.position) * speed
	else:
		move = Vector2.ZERO
	if player != null and move.x < 0:
		$AnimatedSprite.flip_h = true
	elif player != null and move.x > 0:
		$AnimatedSprite.flip_h = false
	move = move_and_collide(move)

func got_shot():
		move = Vector2.ZERO
		if player != null :
			turnoff()
# warning-ignore:return_value_discarded
		$timer.connect("timeout", self, "queue_free")
		$timer.set_wait_time(0.5)
		$timer.start()
		if $music/death.playing == false:
			$music/death.play()
		$AnimatedSprite.play("hit")
		gotShot = true
		$Timer2.set_wait_time(0.5)
		$Timer2.start()

func turnoff():
	player = null
	$kill_range.set_collision_layer_bit(1,false)
	$kill_range.set_collision_mask_bit(0,false)
	set_collision_layer_bit(3,false)
	set_collision_mask_bit(5,false)
	$detection_range.queue_free()
	$detection_range/CollisionShape2D.queue_free()
	if $music/death.playing == false:
		$music/death.play()
	$AnimatedSprite.play("hit")

func _on_detection_range_body_entered(body):
	if body != self and gotShot == false :
		player = body

# warning-ignore:unused_argument
func _on_detection_range_body_exited(body):
	player = null
	if gotShot == false :
		$AnimatedSprite.play("flying")
	else:
		if $music/death.playing == false:
			$music/death.play()
		$AnimatedSprite.play("hit")

func _on_Timer_timeout():
	var loot = LOOT.instance()
	loot.moreLoot()
	get_parent().add_child(loot)
	loot.position = $Position2D.global_position

# warning-ignore:unused_argument
func _on_kill_range_body_entered(body):
	body.got_shot(10)


func _on_collision_range_body_entered(body):
		is_colliding = true
		colliding_player = body
		$AnimatedSprite.play("attack")
		$attackTimer.set_wait_time(1)
		$attackTimer.start()


func _on_collision_range_body_exited(body):
	if colliding_player != null :
		colliding_player = null
		if gotShot == false :
			$AnimatedSprite.play("idle")
		else :
			if $music/death.playing == false:
				$music/death.play()
			$AnimatedSprite.play("hit")



func _on_attackTimer_timeout():
	if colliding_player != null :
		$AnimationPlayer.play("attack")
	if colliding_player != null :
		colliding_player.got_shot(damage)

