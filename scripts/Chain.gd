extends KinematicBody2D

var initialDirection 
var direction := Vector2(0,0)
var tip := Vector2(0,0)
var SPEED = 3
var flying = false

func shoot(dir: Vector2) -> void:
	direction = dir.normalized()

func _physics_process(_delta: float) -> void:
	rotation = direction.angle() + PI/2
# warning-ignore:return_value_discarded
	move_and_collide(direction * SPEED)
# warning-ignore:unused_argument
func _on_Area2D_body_entered(body):
	SPEED = 0


# warning-ignore:unused_argument
func _on_VisibilityNotifier2D_viewport_exited(viewport):
	if get_parent().get_node("player").isTeleporting == false:
		Engine.time_scale = 1
		queue_free()
		get_parent().get_node("player").get_node("JoyStick").get_node("cancelTeleport").visible = false
		get_parent().get_node("player").teleport_shot = false
