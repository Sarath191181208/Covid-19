extends Area2D
const QUESTION = preload("res://scenes/questions.tscn")

func _ready():
	if Global.save(get_tree().current_scene.name) == false:
		queue_free()

func _on_box_body_entered(body):
		var question = QUESTION.instance()
		question.set_global_position(Vector2(0,0))
		body.get_node("CanvasLayer").add_child(question)
		queue_free()
	
