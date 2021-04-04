extends StaticBody2D

func _ready():
	pass
	
# warning-ignore:unused_argument
func got_shot(damage):
	$AnimatedSprite.play("fade")
	$CollisionShape2D.disabled = true
	if $deadShield.playing == false:
		$deadShield.play()
# warning-ignore:return_value_discarded
	$timer.connect("timeout", self, "queue_free")
	Global.shield  = false
	$timer.start()
