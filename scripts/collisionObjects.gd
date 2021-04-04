extends Area2D

# warning-ignore:unused_argument
func _on_collisionObjects_body_entered(body):
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()


func _on_collisionObjects_area_entered(area):
	area.queue_free()
