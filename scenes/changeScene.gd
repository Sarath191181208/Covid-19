extends Area2D


func _on_changeScene_body_entered(body):
	get_tree().change_scene("res://scenes/leve"+str(int(get_tree().current_scene.name)+1) + ".tscn")
	print("res://scenes/"+str(int(get_tree().current_scene.name)+1) + ".tscn")
	if Global.unlocked_levels < int(get_tree().current_scene.name)+1 :
		Global.unlocked_levels += 1

