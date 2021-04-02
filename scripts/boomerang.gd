extends Area2D
export var speed = 300
var direction = 1
var velocity = Vector2()
var player = get_parent()
var retrn = false
func changingDirection(dir):
	direction = dir
	if dir == 1 :
		$Sprite.flip_h = false
	if dir == -1 :
		$Sprite.flip_h = true

func _physics_process(delta):
	if retrn == false:
		velocity.x = speed * delta * direction
		translate(velocity)


func _on_boomerang_body_entered(body):
	body.got_shot()


func _on_Timer_timeout():
	changingDirection(-direction)
	speed += 100
	$Timer2.start()




func _on_Timer2_timeout():
	queue_free()
