extends Node2D


func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().paused = not get_tree().paused
		visible = not visible
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
		get_tree().paused = false
