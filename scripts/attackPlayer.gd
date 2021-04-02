extends Area2D
export var damage = 10
export var speed = 300
var direction = 1
var velocity = Vector2()

func changingDirection(dir):
	direction = dir
	if dir == -1 :
		$Sprite.flip_h = true

func _physics_process(delta):
	velocity.x = speed * delta * direction
	translate(velocity)


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	
func _on_attack_body_entered(body):
	# goes to the body entered and checks for function got shot
	body.got_shot(damage)
	# frees the object <fireball from space>
	queue_free()


func _on_Sprite_animation_finished():
	queue_free()
