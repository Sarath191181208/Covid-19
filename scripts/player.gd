extends KinematicBody2D

export(int) var health = 100
export var JUMPFORCE = -700
export var speed = 300
export var time = 0
export var costAttack = 2

var coins = 0  + Global.ammo
var velocity = Vector2(0,0)
var snap = Vector2.ZERO
var heldTime = 0

var held = false
var isJumping = false
var coins_zero = false
var alreadyPlayed = true
var Timer_once = false


const GRAVITY = 30

onready var camera = $Camera2D/ScreenShake
const SHIELD = preload("res://scenes/shield.tscn")
var FIREBALL = preload("res://scenes/attack.tscn")
# warning-ignore:unused_argument
func _ready():
	$input_buttons/fire/TextureProgress.value = 0
	experienceUpdate()
	if Global.boomerang == true :
		FIREBALL = preload("res://scenes/boomerang.tscn")
	if Global.shield == true:
		var shield = SHIELD.instance()
		add_child(shield)
		shield.position = $shieldPosition.position 
		if $Musics/shield.playing == false:
			$Musics/shield.play()
		Global.shield = false
	$CanvasLayer/time.text = String(time)
	$CanvasLayer/coins_collected.text = String(coins)
	$level_timer.set_wait_time(1)
	$level_timer.start()
	if not is_on_floor():
		isJumping = true
func Time():
	time -= 1
	$CanvasLayer/time.text = String(time)
	if time == 0 :
# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()
func _physics_process(delta):
	if isJumping == true and is_on_floor():
		camera.shake()
		isJumping = false
	if health <= 0 and Timer_once == false :
		$Musics/death.play()
		$timer.set_wait_time(1)
		$timer.start()
		Timer_once = true
		
	$CanvasLayer/lifeBar.value = health
#Doing this because of sprite being on oneside which causes problems with collission layers
	if $AnimatedSprite.flip_h == true :
		$AnimatedSprite.position.x = -30
	else :
		$AnimatedSprite.position.x = 30
#checking the player input and playing animations
	if $Musics/walk.playing == true and Input.is_action_just_released("right"):
		$Musics/walk.stop()
	if $Musics/walk.playing == true and Input.is_action_just_released("left"):
		$Musics/walk.stop()
	if Input.is_action_pressed("right"):
		velocity.x = speed
		$AnimatedSprite.play("walk")
		$AnimatedSprite.flip_h = false
		if $Musics/walk.playing == false:
			$Musics/walk.play()
	elif Input.is_action_pressed("left") :
		velocity.x = -speed

		$AnimatedSprite.play("walk")
		$AnimatedSprite.flip_h = true
		if $Musics/walk.playing == false:
			$Musics/walk.play()
	
	else:
		$AnimatedSprite.play("Idle")
	if Input.is_action_just_pressed("jump")&& is_on_floor():
		jump()
	if Input.is_action_pressed("fire"):
		heldTime += 1
		$input_buttons/fire/TextureProgress.value = heldTime
		if heldTime >= 10:
			held = true
	if Input.is_action_just_released("fire"):
		held = false 
		heldTime = 0
	if Input.is_action_just_pressed("fire"):
		if coins > 1:
			$Musics/fire.play()
			coins -= costAttack
			updateHub()
			$attackChangingTimer.set_wait_time(float(0.2))
			$attackChangingTimer.start()
				
		else:
			Input.vibrate_handheld(200)

	if not is_on_floor():
		snap = Vector2.DOWN

#Adding gravity to player this function runs about 60 times per second 
# 	=> body accelerates due to continious change in velocity
	velocity.y = velocity.y + GRAVITY
	velocity = move_and_slide_with_snap(velocity,snap * 64 ,Vector2.UP)
	velocity.x = lerp(velocity.x , 0 , 0.2)

func addcoin():
	coins += 1
	updateHub()

# warning-ignore:unused_argument


func got_shot(enemy_damage):
# warning-ignore:return_value_discarded
	camera.shake()
	health -= enemy_damage
	$Musics/damage.play()
	Input.vibrate_handheld(300)


func get_position():
	return $CanvasLayer/Position2D2.position

func _on_level_timer_timeout():
	Time()


func _on_timer_timeout():
	get_tree().change_scene("res://scenes/levelSelector.tscn")

func jump(force = null):
		isJumping = true
		if force == null:
			velocity.y = JUMPFORCE
		else:
			velocity.y = force
		snap = Vector2.ZERO
		if $Musics/jump.playing == false and alreadyPlayed == false :
			$Musics/jump.play()
			alreadyPlayed = true
		alreadyPlayed = false

func experienceUpdate():

	if Global.experience >= $CanvasLayer/expBar.max_value:
		var extra = Global.experience - $CanvasLayer/expBar.max_value
		Global.coins += Global.expLevel * 5 + 1
		Global.expLevel += 1
		Global.experience = 0  + int(extra)
		$CanvasLayer/exp.text = String(Global.expLevel)
		$CanvasLayer/expBar/Particles2D.set_emitting(true)
		$CanvasLayer/expBar/Timer.start()
		$CanvasLayer/expBar.value = Global.experience
		
	$CanvasLayer/expBar.max_value = Global.expLevel * 50 + 50
	$CanvasLayer/exp.text = String(Global.expLevel)
#	$CanvasLayer/expBar.value = Global.experience
	$exp.interpolate_property($CanvasLayer/expBar,"value",$CanvasLayer/expBar.value,Global.experience,0.7,Tween.TRANS_LINEAR,Tween.EASE_OUT)
	$exp.start()
	
func updateHub():
	$CanvasLayer/time.text = String(time)
	$CanvasLayer/coins_collected.text = String(coins)
func addMastercoin():
	Global.coins += 2000
	updateHub()



func _on_attackChangingTimer_timeout():
	var fireball = FIREBALL.instance()
	Input.vibrate_handheld(350)
# --> changing the direction of fireball based on players facing direction
	if $AnimatedSprite.flip_h == true :
		fireball.changingDirection(-1)
	else :
		fireball.changingDirection(1)
	fireball.addExperienceTo(self)
	if Input.is_action_just_released("fire"):
		held = false
		heldTime = 0
	if held == false:
	#adding fireball
		get_parent().add_child(fireball)
		fireball.position = $Position2D.global_position
	else:
		add_child(fireball)
		fireball.position = Vector2(0,0)
	heldTime = 0
	$input_buttons/fire/TextureProgress.value = 0
	held = false


func _on_Timer_timeout():
	$CanvasLayer/expBar/Particles2D.set_emitting(false)
