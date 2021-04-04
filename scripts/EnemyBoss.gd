extends Node2D

var velocity = Vector2.ZERO
var random = RandomNumberGenerator.new()
const enemies = [preload("res://scenes/enemy.tscn"),preload("res://scenes/playerFollower.tscn"),preload("res://scenes/follow_rocket.tscn"),preload("res://scenes/slimeEnemy.tscn")]
const powerups = [preload("res://scenes/Health_powerup.tscn")]
var direction = -1
export (int) var speed = 400
export(int) var DashDamage = 20
var move = false
var bullet = preload("res://scenes/attackPlayer.tscn")


func _on_VisibilityNotifier2D_screen_entered():
	$KinematicBody2D/attackTimer.start()
	$KinematicBody2D/spwanTimer.start()
	$KinematicBody2D/shootTimer.start()
	$KinematicBody2D/damageTimer.start()
	



func _on_spwanTimer_timeout():
	var random_number = random.randi_range(0,enemies.size()-1)
# warning-ignore:unused_variable
	var enemy = enemies[random_number].instance()
	get_parent().add_child(enemy)
	if random_number == 1:
		enemy.position = $KinematicBody2D/Path2D.get_curve().get_point_position(2)+global_position
	else:
		enemy.position = $KinematicBody2D/Path2D.get_curve().get_point_position(0)+global_position
	
	


func _on_damageTimer_timeout():
	var random_number = random.randi_range(0,2)
	$KinematicBody2D/Area2D.position = $KinematicBody2D/Path2D.get_curve().get_point_position(random_number)
	$KinematicBody2D/Area2D/CollisionShape2D.disabled = false
	

func _physics_process(delta):
	if move == true:
		velocity.x =  speed * delta * direction
		translate(velocity)
func _on_attackTimer_timeout():
	move = true
	$KinematicBody2D/attackTimer.stop()
	$KinematicBody2D/return.start()


func _on_return_timeout():
	direction *= -1
	var random_number = random.randi_range(0,powerups.size()-1)
	var powerup = powerups[random_number].instance()
	get_parent().add_child(powerup)
	powerup.position = position
	$KinematicBody2D/Sprite.flip_h = true
	$KinematicBody2D/return.stop()
	$KinematicBody2D/dashCompleted.start()


func _on_dashCompleted_timeout():
	direction *= -1
	$KinematicBody2D/Sprite.flip_h = false
	move = false
	$KinematicBody2D/dashCompleted.stop()
	$KinematicBody2D/return.stop()
	$KinematicBody2D/attackTimer.start()

func _on_attackArea_body_entered(body):
	body.got_shot(DashDamage)
	body.jump(-400,-1100)


func _on_shootTimer_timeout():
	var bullet_a = bullet.instance()
	var bullet_b = bullet.instance()
	var bullet_c = bullet.instance()
	bullet_a.direction = direction
	bullet_b.direction = direction
	bullet_c.direction = direction
	get_parent().add_child(bullet_a)
	get_parent().add_child(bullet_b)
	get_parent().add_child(bullet_c)
	bullet_b.shortGun = true
	bullet_c.shortGun = true
	bullet_c.y_direction = -1
	bullet_a.position = $KinematicBody2D/Path2D.get_curve().get_point_position(1)+global_position
	bullet_b.position = $KinematicBody2D/Path2D.get_curve().get_point_position(1)+global_position
	bullet_c.position = $KinematicBody2D/Path2D.get_curve().get_point_position(1)+global_position
