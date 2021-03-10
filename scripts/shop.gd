extends Node2D

func _physics_process(delta):
	$Add_ammo.connect("pressed",self,"addCoin")
	$Button.connect("pressed",self,"changeScene")
func _ready():
	$CanvasLayer/Label.text = String(Global.coins)
func addCoin():
	if Global.coins > 0:
		Global.coins -= 1
		Global.ammo += 1
	else :
		$Add_ammo.disabled = true
	_ready()

	

func changeScene():
	get_tree().change_scene("res://scenes/levelSelector.tscn")
