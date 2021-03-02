extends KinematicBody2D

# velocity of player
var velocity = Vector2(0,0)

#setting the  linear velocity of the player
const v = 300
const GRAVITY = 30
const JUMPFORCE = -700
#funcion delta runs 60 times a second

func _physics_process(delta):
	if Input.is_action_pressed("right"):
		velocity.x = v
		$AnimatedSprite.play("walk")
		$AnimatedSprite.flip_h = false
	elif Input.is_action_pressed("left"):
		velocity.x = -v
		$AnimatedSprite.play("walk")
		$AnimatedSprite.flip_h = true
	else:
		$AnimatedSprite.play("Idle")
	if not is_on_floor():
		$AnimatedSprite.play("jump")
	velocity.y = velocity.y + GRAVITY
	if Input.is_action_just_pressed("jump")&& is_on_floor():
		velocity.y = JUMPFORCE
	velocity = move_and_slide(velocity,Vector2.UP)
	velocity.x = lerp(velocity.x , 0 , 0.2)


func _on_Area2D_body_entered(body):
	get_tree().change_scene("res://scenes/leve1.tscn")




func _on_death_range_body_entered(body):
	get_tree().change_scene("res://scenes/leve1.tscn")
