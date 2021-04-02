extends KinematicBody2D
var player = null
const FIREBALL = preload("res://scenes/attackPlayer.tscn")
const LOOT = preload("res://scenes/coin.tscn")
export var experience = 20 
var gotShot = false
var audio_played = false
func got_shot():
		if player != null :
			turnoff()
# warning-ignore:return_value_discarded
		$timer.connect("timeout", self, "queue_free")
		$timer.set_wait_time(1.4)
		$timer.start()
		if $Audio/death.playing == false and audio_played == false :
			$Audio/death.play()
			audio_played = true
		$Sprite.play("dead")
		gotShot = true
		$Timer2.set_wait_time(1.4)
		$Timer2.start()
		

func fire():
	if player != null:
		var fireball = FIREBALL.instance()
		fireball.position = $Position2D.global_position
		if $Sprite.flip_h == true:
			fireball.changingDirection(1)
		else:
			fireball.changingDirection(-1)
		get_parent().get_parent().add_child(fireball)
		$Timer.set_wait_time(2)
		$Timer.start()
		


func turnoff():
	player = null
	$death_range.set_collision_layer_bit(1,false)
	$death_range.set_collision_mask_bit(0,false)
	$death_range/CollisionShape2D.disabled = true
	$death_range.queue_free()
	$death_range/CollisionShape2D.queue_free()
	set_collision_layer_bit(3,false)
	set_collision_mask_bit(5,false)
	set_collision_mask_bit(0,false)
	$attackRange/range.disabled = true
	$attackRange.queue_free()
	$attackRange/range.queue_free()
	$Sprite.play("dead")
	
func _on_Timer_timeout():
	if player != null:
		fire()


func _on_attackRange_body_entered(body):
	if body != self and gotShot == false :
		player = body
		$Sprite.play("fire")
	elif player != null and gotShot ==true :
		if $Audio/death.playing == false and audio_played == false :
			$Audio/death.play()
			audio_played = true
		$Sprite.play("dead")

# warning-ignore:unused_argument
func _on_attackRange_body_exited(body):
	player = null
	if gotShot == false :
		$Sprite.play("idle")
	else:
		$Sprite.play("dead")
		if $Audio/death.playing == false and audio_played == false :
			$Audio/death.play()
			audio_played = true


func _on_Timer2_timeout():
	var loot = LOOT.instance()
	loot.moreLoot()
	get_parent().add_child(loot)
	loot.position = $Position2D.global_position


# warning-ignore:unused_argument
func _on_death_range_body_entered(body):
# warning-ignore:return_value_discarded
	body.got_shot(100)
