extends KinematicBody2D

export var JUMPFORCE = -700
export var speed = 300

var coins = 0
var velocity = Vector2(0,0)
var coins_zero = false

const GRAVITY = 30
const FIREBALL = preload("res://scenes/attack.tscn")
# warning-ignore:unused_argument
func _ready():
#when the sene loads coins text will be chaged from ## to 0<coins>
	$CanvasLayer/coins_collected.text = String(coins)
func _physics_process(delta):
#Doing this because of sprite being on oneside which causes problems with collission layers
	if $AnimatedSprite.flip_h == true :
		$AnimatedSprite.position.x = -30
	else :
		$AnimatedSprite.position.x = 30
#checking the player input and playing animations
	if Input.is_action_pressed("right"):
		velocity.x = speed
		$AnimatedSprite.play("walk")
		$AnimatedSprite.flip_h = false
	elif Input.is_action_pressed("left"):
		velocity.x = -speed
		$AnimatedSprite.play("walk")
		$AnimatedSprite.flip_h = true
	else:
		$AnimatedSprite.play("Idle")
	if Input.is_action_just_pressed("jump")&& is_on_floor():
		velocity.y = JUMPFORCE
	if Input.is_action_just_pressed("fire"):
		if coins != 0 :
			var fireball = FIREBALL.instance()
			coins -= 1
			_ready()
# --> changing the direction of fireball based on players facing direction
			if $AnimatedSprite.flip_h == true :
				fireball.changingDirection(-1)
			else :
				fireball.changingDirection(1)
			#adding fireball
			get_parent().add_child(fireball)
			fireball.position = $Position2D.global_position
	if not is_on_floor():
		$AnimatedSprite.play("jump")
#Adding gravity to player this function runs about 60 times per second 
# 	=> body accelerates due to continious change in velocity
	velocity.y = velocity.y + GRAVITY

		
		

	velocity = move_and_slide(velocity,Vector2.UP)
	velocity.x = lerp(velocity.x , 0 , 0.2)
func addcoin():
	coins += 1
	_ready()
# warning-ignore:unused_argument
func _on_Area2D_body_entered(body):
# warning-ignore:return_value_discarded
# when colliding with the limit restarting the game
	get_tree().change_scene("res://scenes/leve1.tscn")
# warning-ignore:unused_argument
func _on_death_range_body_entered(body):
# warning-ignore:return_value_discarded
# when collided with enemy restarting the scene
	get_tree().change_scene("res://scenes/leve1.tscn")
