extends Node2D

func _physics_process(delta):
	$GridContainer/Button.connect("pressed",self,"addCoin")
	
func addCoin():
	if Global.coins != 0:
		Global.coins -= 1
	Global.ammo += 1
	print(Global.coins)
