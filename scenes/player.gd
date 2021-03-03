extends KinematicBody2D
signal fired
# velocity of player
var velocity = Vector2(0,0)
var coins_zero = false
#setting the  linear velocity of the player
export var v = 300
const GRAVITY = 30
export var JUMPFORCE = -700
#funcion delta runs 60 times a second

const FIREBALL = preload("res://scenes/attack.tscn")
# warning-ignore:unused_argument
func _physics_process(delta):

	if $AnimatedSprite.flip_h == true :
		$AnimatedSprite.position.x = -30
	else :
		$AnimatedSprite.position.x = 0
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
		
		
	if Input.is_action_just_pressed("fire"):
		emit_signal("fired")
		if coins_zero != true :
			var fireball = FIREBALL.instance()
	
			if $AnimatedSprite.flip_h == true :
				fireball.changingDirection(-1)
			else :
				fireball.changingDirection(1)
			
			get_parent().add_child(fireball)
			fireball.position = $Position2D.global_position
	velocity = move_and_slide(velocity,Vector2.UP)
	velocity.x = lerp(velocity.x , 0 , 0.2)



# warning-ignore:unused_argument
func _on_Area2D_body_entered(body):
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/leve1.tscn")




# warning-ignore:unused_argument
func _on_death_range_body_entered(body):
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/leve1.tscn")




func _on_CanvasLayer_coins_zero():
	coins_zero = true
