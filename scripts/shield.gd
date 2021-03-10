extends StaticBody2D

func _ready():
	pass
	
func got_shot(damage):
	$AnimatedSprite.play("fade")
	$CollisionShape2D.disabled = true
	$timer.connect("timeout", self, "queue_free")
	$timer.start()
