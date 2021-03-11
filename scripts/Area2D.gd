extends Area2D


func _on_body_entered(body):
	get_tree().change_scene("res://scenes/levelSelector.tscn")


func _on_Area2D2_body_entered(body):
	get_tree().change_scene("res://scenes/levelSelector.tscn")
