extends KinematicBody2D


var direction := Vector2(0,0)
var tip := Vector2(0,0)
export (int) var maximimLength = 900
var SPEED = 3	
var flying = false

func shoot(dir: Vector2) -> void:
	direction = dir.normalized()


func _physics_process(_delta: float) -> void:
	rotation = direction.angle() + PI/2
# warning-ignore:return_value_discarded
	move_and_collide(direction * SPEED)
	if $Sprite.position.length() > maximimLength:
		queue_free()
		get_parent().get_node("player").teleport_shot = false


# warning-ignore:unused_argument
func _on_Area2D_body_entered(body):
	SPEED = 0
