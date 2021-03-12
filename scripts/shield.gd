extends StaticBody2D

func _ready():
	pass
	
func got_shot(damage):
	$AnimatedSprite.play("fade")
	$CollisionShape2D.disabled = true
	if $deadShield.playing == false:
		$deadShield.play()
	$timer.connect("timeout", self, "queue_free")
	Global.shield  = false
	$timer.start()
