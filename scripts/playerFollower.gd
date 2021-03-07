extends KinematicBody2D

export var speed = 0.8
var move = Vector2.ZERO
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
		$AnimatedSprite.play("hit")


func _on_Timer_timeout():
	var loot = LOOT.instance()
	loot.moreLoot()
	get_parent().add_child(loot)
	loot.position = $Position2D.global_position


# warning-ignore:unused_argument
func _on_kill_range_body_entered(body):
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()
