extends KinematicBody2D
export var speed = 0.9
export var damage = 10

var random = RandomNumberGenerator.new()
# if a player enters the range the player == .the object 
var player =  null 
var colliding_player = null
var move = Vector2.ZERO
# sprite is facing left so direction = -ve
var direction = -1

var gotShot = false
var is_colliding = false
var is_played_walk = false
var is_played_dead = false

const GRAVITY = 20

const BOX = preload("res://scenes/box.tscn")
const LOOT = preload("res://scenes/coin.tscn")
# running a function after a time interval
onready var timer = get_node("timer2")
# warning-ignore:unused_argument

func _physics_process(delta):
# poaitioning for checkking if the enemy is colliding with player or not
	$floor_checker.position.x = $CollisionShape2D.shape.get_extents().x * direction
	
	move = Vector2.ZERO
	move.y = move.y + GRAVITY

	if is_on_floor():
		move.y = 0
	move = move_and_slide(move,Vector2.UP)
# putting speed of player = speed of enemy
	if player != null :
		move.x = position.direction_to(player.position).x * speed
# playing animations and flipping the enemy
		if move.x > 0 :
			direction = 1
			if is_colliding == false :
				$AnimatedSprite.play("walk")
			$AnimatedSprite.flip_h = false
		elif move.x < 0 :
			direction = -1
			if is_colliding == false:
				$AnimatedSprite.play("walk")
			$AnimatedSprite.flip_h = true
		else :
			$AnimatedSprite.play("idle")
			if $Audio/idle.playing == false :
				$Audio/idle.play()
			
	else :
		move.x = Vector2.ZERO.x
	
	if not $floor_checker.is_colliding():
		move.x = 0
		if player != null :
			if $Audio/idle.playing == false :
				$Audio/idle.play()
			$AnimatedSprite.play("idle")
	if $Audio/walk.playing == false and is_on_floor() and move.x != 0 and player != null :
		$Audio/walk.play()
	move = move_and_collide(move)

func got_shot():
	if player != null :
		player = null
	turnoff()
	$AnimatedSprite.play("dead")
	if $Audio/dead.playing == false and is_played_dead == false:
		$Audio/dead.play()
		is_played_dead = true
	gotShot = true
# warning-ignore:return_value_discarded
	$timer.connect("timeout", self, "queue_free")
	$timer.set_wait_time(1.4)
	$timer.start()
	timer.set_wait_time(1.4)
	timer.start()

func turnoff():
	$CollisionShape2D.disabled = true
	set_collision_layer_bit(3,false)
	set_collision_mask_bit(5,false)
	if $detecting_range != null :
		$detecting_range.queue_free()
		$detecting_range/CollisionShape2D.queue_free()
	$AnimatedSprite.play("dead")
# warning-ignore:unused_argument

func _on_detecting_range_body_entered(body):
	if body != self :
		player = body
		
func _on_detecting_range_body_exited(body) :
	move = Vector2.ZERO
	if gotShot == false:
		$AnimatedSprite.play("idle")
		if $Audio/idle.playing == false :
			$Audio/idle.play()
	player = null


func _on_timer2_timeout():
	var loot = LOOT.instance()
	loot.moreLoot()
	get_parent().add_child(loot)
	random.randomize()
	var random_number = random.randf_range(0,100)
	if random_number >= 95 :
		var box = BOX.instance()
		box.position = $Position2D.global_position
		get_parent().add_child(box)
	loot.position = $Position2D.global_position

func _on_collision_range_body_entered(body):
	is_colliding = true
	colliding_player = body
	if gotShot == false :
		if $Audio/attack.playing == false :
			$Audio/attack.play()
		$AnimatedSprite.play("attack")
	$attackTimer.set_wait_time(1)
	$attackTimer.start()
	
func _on_attackTimer_timeout():
	if colliding_player != null :
		colliding_player.got_shot(damage)

# warning-ignore:unused_argument
func _on_collision_range_body_exited(body):
	is_colliding = false
	if colliding_player != null :
		colliding_player = null
		if gotShot == false :
			$AnimatedSprite.play("idle")
			if $Audio/idle.playing == false :
				$Audio/idle.play()
		else :
			if $Audio/dead.playing == false and is_played_dead == false:
				$Audio/dead.play()
				is_played_dead = true
			$AnimatedSprite.play("dead")
