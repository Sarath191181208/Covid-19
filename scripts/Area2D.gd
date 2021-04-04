extends Area2D


# warning-ignore:unused_argument
func _on_body_entered(body):
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/levelSelector.tscn")


# warning-ignore:unused_argument
func _on_Area2D2_body_entered(body):
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/levelSelector.tscn")



# warning-ignore:unused_argument
func _on_Area2D_body_entered(body):
	pass # Replace with function body.
