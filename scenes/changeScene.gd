extends Area2D

var entered = false

const QUESTION = preload("res://scenes/questions.tscn")

func _physics_process(delta):
		if get_tree().paused == false and entered == true :
			get_tree().change_scene("res://scenes/leve"+str(int(get_tree().current_scene.name)+1) + ".tscn")
# warning-ignore:unused_argument
func _on_changeScene_body_entered(body):
# warning-ignore:return_value_discarded
	Global.shield = false
	Global.ammo = 0
	Global.coins += body.coins
	var question = QUESTION.instance()
	question.set_global_position(Vector2(0,0))
	body.get_node("CanvasLayer").add_child(question)
	get_tree().paused = true
	entered = true
	if int(get_tree().current_scene.name)+1 == 5 :
		get_tree().change_scene("res://scenes/levelSelector.tscn")
	if Global.unlocked_levels < int(get_tree().current_scene.name)+1 :
		Global.unlocked_levels += 1

