extends KinematicBody2D

export var speed = 50
export(int) var damage = 10
const GRAVITY = 5
var velocity = Vector2.ZERO
var direction = -1
const LOOT = preload("res://scenes/coin.tscn")
func _ready():
	$floor_checker.position.x = $CollisionShape2D.shape.get_extents().x * direction
	velocity.x = speed
# warning-ignore:unused_argument
func _physics_process(delta):
	if not $floor_checker.is_colliding() :

		direction = (direction) * -1
		if direction == -1 :
			$AnimatedSprite.flip_h = false
			velocity.x = -speed
		else :
			$AnimatedSprite.flip_h = true
			velocity.x = speed
		$floor_checker.position.x = $CollisionShape2D.shape.get_extents().x * direction

	velocity.y += GRAVITY
	if is_on_floor():
		velocity.y = 0
# warning-ignore:return_value_discarded
	move_and_slide(velocity,Vector2.UP)


func _on_Area2D_body_entered(body):
	body.jump(-400)
	body.got_shot(damage - 5)
	$AnimatedSprite.play("dead")
	var loot = LOOT.instance()
	loot.moreLoot()
	get_parent().add_child(loot)
	loot.position = $Position2D.global_position
	queue_free()

