extends Area2D
export var speed = 3000
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
	body.got_shot()
	queue_free()
