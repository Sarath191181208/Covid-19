extends Node2D

const IDLE_DURATION = 1.0
var move_to = Vector2(0,20) * 256
export var speed = 3.0
export var damage = 3
var start = false
var follow = Vector2.ZERO
var onPlatform  = false

onready var platform = $KinematicBody2D
onready var tween = $Tween


func _on_Area2D_body_entered(body):
	body.camera.shake(2,2,15,20)
	$KinematicBody2D/Area2D/Sprite.modulate = "ff0000"
	$KinematicBody2D/Timer.set_wait_time(0.1)
	$KinematicBody2D/Timer.start()
	body.got_shot(damage)
	onPlatform = true

func _init_tween():
	var duration = move_to.length() / float(speed * 256)
	tween.interpolate_property(self,"follow",Vector2.ZERO,move_to,duration,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT, IDLE_DURATION)
	start = true
	tween.start()
	
# warning-ignore:unused_argument
func _physics_process(delta):
	if start == true:
		platform.position = platform.position.linear_interpolate(follow,0.075)
	

func _on_Timer_timeout():	
	_init_tween()
	
func _on_VisibilityNotifier2D_screen_exited():
	if onPlatform == true:
		$KinematicBody2D.queue_free()
		queue_free()


func _on_Area2D_body_exited(body):
	body.camera.shake(0,5,10,10)
