extends Area2D


# warning-ignore:unused_argument
func _on_changeScene_body_entered(body):
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/leve"+str(int(get_tree().current_scene.name)+1) + ".tscn")
	if Global.unlocked_levels < int(get_tree().current_scene.name)+1 :
		Global.unlocked_levels += 1

