extends Area2D
export var speed = 300
var direction = 1
var velocity = Vector2()
var player

const EXP_ANIMATION = preload("res://scenes/ExperiencePoints.tscn")

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
	body.got_shot()
	Global.experience += body.experience
	var exp_animation = EXP_ANIMATION.instance()
	exp_animation.text(body.experience)
	body.add_child(exp_animation)
	exp_animation.position = Vector2(0,0)
	player.experienceUpdate()
	queue_free()

func addExperienceTo(body):
	player = body
func _on_Sprite_animation_finished():
	queue_free()
