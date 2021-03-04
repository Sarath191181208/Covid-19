extends Area2D


func _on_coin_body_entered(body):
	body.addcoin()
	$AnimationPlayer.play("bounce")
	set_collision_mask_bit(0,false)
func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
