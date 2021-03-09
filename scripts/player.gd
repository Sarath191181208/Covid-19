extends KinematicBody2D

export(int) var health = 100
export var JUMPFORCE = -700
export var speed = 300
export var time = 0

var coins = 0
var velocity = Vector2(0,0)
var coins_zero = false
var snap = Vector2.ZERO

const GRAVITY = 30
const FIREBALL = preload("res://scenes/attack.tscn")
# warning-ignore:unused_argument
func _ready():
	$CanvasLayer/time.text = String(time)
	$CanvasLayer/coins_collected.text = String(coins)
	$level_timer.set_wait_time(1)
	$level_timer.start()
func Time():
	time -= 1
	$CanvasLayer/time.text = String(time)
	if time == 0 :
# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()
func _physics_process(delta):
	if health <= 0 :
		get_tree().change_scene("res://scenes/levelSelector.tscn")
	$CanvasLayer/lifeBar.value = health
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
		snap = Vector2.ZERO
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
		snap = Vector2.DOWN
		$AnimatedSprite.play("jump")

#Adding gravity to player this function runs about 60 times per second 
# 	=> body accelerates due to continious change in velocity
	velocity.y = velocity.y + GRAVITY
	velocity = move_and_slide_with_snap(velocity,snap * 64 ,Vector2.UP)
	velocity.x = lerp(velocity.x , 0 , 0.2)

func addcoin():
	coins += 1
	_ready()

# warning-ignore:unused_argument


func got_shot(enemy_damage):
# warning-ignore:return_value_discarded
	health -= enemy_damage
# warning-ignore:unused_argument
func _on_changeScene_area_entered(area):
	pass # Replace with function body.

func _on_level_timer_timeout():
	Time()
