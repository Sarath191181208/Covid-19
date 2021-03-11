extends Area2D
export var heal = 50

func _ready():
	pass


func _on_Health_powerup_body_entered(body):
	body.health += heal
	$AudioStreamPlayer.play()
	if body.health > 100 :
		body.health = 100
	$AnimationPlayer.play("bounce")
	set_collision_layer_bit(4,false)
	$CollisionShape2D.disabled = true

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
