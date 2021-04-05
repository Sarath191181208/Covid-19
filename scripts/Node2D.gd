extends Node2D


# warning-ignore:unused_argument
func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().paused = not get_tree().paused
		visible = not visible
	if Input.is_action_just_pressed("restart"):
# warning-ignore:return_value_discarded
		Engine.time_scale = 1
		get_tree().reload_current_scene()
		get_tree().paused = false
	if Input.is_action_just_pressed("exit"):
# warning-ignore:return_value_discarded
		Engine.time_scale = 1
		get_tree().change_scene("res://scenes/levelSelector.tscn")
		get_tree().paused = false
		
