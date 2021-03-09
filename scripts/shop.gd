extends Node2D

func _physics_process(delta):
	$GridContainer/Button.connect("pressed",self,"addCoin")
	$Button.connect("pressed",self,"changeScene")
	
func addCoin():
	if Global.coins != 0:
		Global.coins -= 1
	Global.ammo += 1
	print(Global.coins)
	

func changeScene():
	get_tree().change_scene("res://scenes/levelSelector.tscn")
