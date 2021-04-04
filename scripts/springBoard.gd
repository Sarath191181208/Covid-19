extends Area2D
export(int) var springForce = 1000

var player 
var beforeVelo

func _ready():
	$AnimatedSprite.set_frame(0)


func _on_springBoard_body_entered(body):
	beforeVelo = body.beforeVelocity
	player = body
	$AnimationPlayer.play("changePositionOfCollisionShape")
	$AnimatedSprite.play("onBoard")



func _on_AnimatedSprite_animation_finished():
	$AnimatedSprite.stop()
	$AnimatedSprite.set_frame(0)
	player.jump((-1 * (beforeVelo) )-springForce)
	player = null

