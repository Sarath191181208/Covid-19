extends KinematicBody2D

export(int) var health = 100
export var JUMPFORCE = -700
export var speed = 300
export var time = 0
export var costAttack = 0
export var look_ahed = 256

var Side
var rotationOfCompass 
var drag
var output
var isTeleporting


var beforeVelocity
var coins = 0  + Global.ammo
var velocity = Vector2(0,0)
var snap = Vector2.ZERO
var heldTime = 0

var held = false
var isJumping = false
var coins_zero = false
var alreadyPlayed = true
var Timer_once = false
var teleport_shot = false

const GRAVITY = 30
onready var joystick = $JoyStick/Joystick
onready var end_position = get_parent().get_node("changeScene").position
onready var camera = $Camera2D/ScreenShake
const CHAIN = preload("res://scenes/Chain.tscn")
const SHIELD = preload("res://scenes/shield.tscn")
var FIREBALL = preload("res://scenes/attack.tscn")
# warning-ignore:unused_argument
func _ready():
	$JoyStick/TextureProgress.value  = 0
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
		$particleMove.emitting = false
		isJumping = true
func Time():
	time -= 1
	$CanvasLayer/time.text = String(time)
	if time == 0 :
# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()
func _physics_process(delta):
	Global.player_position = self.global_position
	$CanvasLayer/marker.rotation = (global_position - end_position).angle() - PI
	if held == false:
		$JoyStick/TextureProgress.value   = 0
	if isJumping == true and is_on_floor():
		if beforeVelocity >= 700:
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
		cameraDamp(1)
		$particleMove.emitting = true
		$particleMove.scale.x = 1
		$particleMove.position.x = -20
		velocity.x = speed
		$AnimatedSprite.play("walk")
		$AnimatedSprite.flip_h = false
		if $Musics/walk.playing == false:
			$Musics/walk.play()
	elif Input.is_action_pressed("left") :
		cameraDamp(-1)
		velocity.x = -speed
		$AnimatedSprite.play("walk")
		$particleMove.emitting = true
		$particleMove.scale.x = -1
		$particleMove.position.x = 20
		$AnimatedSprite.flip_h = true
		if $Musics/walk.playing == false:
			$Musics/walk.play()
	
	else:
		$particleMove.emitting = false
		$AnimatedSprite.play("Idle")
	if Input.is_action_just_released("jump") and not is_on_floor():
		velocity.y *= 0.5
	if Input.is_action_just_pressed("jump")&& is_on_floor():
		jump()
	if Input.is_action_pressed("fire"):
		heldTime += 1
		$JoyStick/TextureProgress.value    = heldTime
		if joystick.output == Vector2.ZERO:
			drag = false
		else:
			drag = true
			output = joystick.output
		if heldTime >= 10:
			held = true
			

	if Input.is_action_just_released("fire"):
		if coins > costAttack:
			$Musics/fire.play()
			coins -= costAttack
			updateHub()
			camera.y = 0
			camera.shake()
			if teleport_shot == false:
				fire()
			else:
				teleport()
		else:
			held = false
			heldTime = 0
			$JoyStick/TextureProgress.value   = 0
			Input.vibrate_handheld(200)


	if not is_on_floor():
		snap = Vector2.DOWN
	beforeVelocity = velocity.y
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

func jump(force = null,x_velo = null ):
		isJumping = true
		if x_velo != null:
			velocity.x = x_velo
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
	$CanvasLayer/expBar.max_value = Global.expLevel * 50 + 50
	if Global.experience >= $CanvasLayer/expBar.max_value:
		var extra = Global.experience - $CanvasLayer/expBar.max_value
		Global.coins += Global.expLevel * 5 + 1
		Global.expLevel += 1
		Global.experience = 0  + int(extra)
		$CanvasLayer/exp.text = String(Global.expLevel)
		$CanvasLayer/expBar/Particles2D.set_emitting(true)
		$CanvasLayer/expBar/Timer.start()
		$CanvasLayer/expBar.value = Global.experience
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

func fire():
	if drag  == false:
		var fireball = FIREBALL.instance()
		Input.vibrate_handheld(350)
	# --> changing the direction of fireball based on players facing direction
		if $AnimatedSprite.flip_h == true :
			fireball.changingDirection(-1)
		else :
			fireball.changingDirection(1)
		fireball.addExperienceTo(self)
		if held == false:
		#adding fireball
			fireball.position = global_position
			get_parent().add_child(fireball)
		else:
			add_child(fireball)
			fireball.position = Vector2(0,0)
	heldTime = 0
	$JoyStick/TextureProgress.value = 0
	held = false
	if drag == true and teleport_shot == false:
		Input.vibrate_handheld(350)
		Engine.time_scale = 0.1
		var chain = CHAIN.instance()
		get_parent().add_child(chain)
		chain.global_position = global_position 
		chain.shoot(output)
		teleport_shot = true
		
		
func teleport():
	$AnimatedSprite/AnimationPlayer.play("fadeIn")
	isTeleporting = true
	yield($AnimatedSprite/AnimationPlayer,"animation_finished")
	isTeleporting = false
	Engine.time_scale = 1
	camera.y = 0
	camera.shake()
	var teleporter = get_parent().get_node("Tip")
	self.position = teleporter.global_position
	teleporter.queue_free()
	$AnimatedSprite/AnimationPlayer.play("fadeOut")
	teleport_shot = false

func cameraDamp(side):
	if Side != side:
		$Camera2D/Tween.interpolate_property($Camera2D,"position",$Camera2D.position,Vector2(side * look_ahed,$Camera2D.position.y),1,Tween.TRANS_QUAD,Tween.EASE_IN)	
		$Camera2D/Tween.start()
		Side = side
#	$Camera2D.position.x = side * look_ahed
func getDistance(vector1,vector2):
	return sqrt((vector1.x - vector2.x)*(vector1.x - vector2.x) + (vector1.y - vector2.y) * (vector1.y - vector2.y))
func _on_Timer_timeout():
	$CanvasLayer/expBar/Particles2D.set_emitting(false)
