extends Node2D

func _ready():
	$Add_ammo.connect("pressed",self,"addCoin")
	$Button.connect("pressed",self,"changeScene")
	$Add_shield.connect("pressed",self,"addShield")
	$CanvasLayer/Label.text = String(Global.coins)
	
func updateCoins():
	$CanvasLayer/Label.text = String(Global.coins)
	

func addCoin():
	if Global.coins > 0:
		Global.coins -= 1
		Global.ammo += 1
	else :
		$Add_ammo.disabled = true
 updateCoins()

	
func addShield():
	if Global.shield == false and Global.coins >=10 :
		$Add_shield.disabled = true
		Global.shield = true
		Global.coins -= 10
	updateCoins()

func changeScene():
	get_tree().change_scene("res://scenes/levelSelector.tscn")
