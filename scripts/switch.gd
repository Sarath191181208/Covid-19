extends Area2D

func _on_Timer_timeout():
	queue_free()

# warning-ignore:unused_argument
func _on_switch_area_entered(area):
	$Timer.start()
	$Sprite.play("on")
