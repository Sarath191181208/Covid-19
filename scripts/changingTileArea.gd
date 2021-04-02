extends Area2D

func _on_Area2D_body_entered(body):
	$Timer.set_wait_time(1)
	$Timer.start()
	
func _on_Timer_timeout():
	
