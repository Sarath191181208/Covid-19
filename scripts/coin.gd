extends Area2D
var add = false
var random = RandomNumberGenerator.new()
func _on_coin_body_entered(body):
#goes to body that entered  and checks for add coin function
	body.addcoin()
	$AudioStreamPlayer.play()
	if add == true :
		body.addcoin()
		add = false
	$AnimationPlayer.play("bounce")
	set_collision_mask_bit(0,false)
	set_collision_layer_bit(4,0)
	
func moreLoot():
	random.randomize()
	var random_number = random.randf_range(0,100)
	if random_number >= 90 :
		add = true

# warning-ignore:unused_argument
func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()

