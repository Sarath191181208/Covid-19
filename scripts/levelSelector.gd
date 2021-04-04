extends Control

func _ready():
	for i in $levels.get_children():
		i.text = i.name
	for i in range($levels.get_child_count()):
		Global.levels.append(i + 1)
	for level in $levels.get_children():
		if str2var(level.name) in range(Global.unlocked_levels + 1 ):
			level.disabled = false
			level.connect('pressed',self,'change_level',[level.name])
		else :
			level.disabled = true
# warning-ignore:return_value_discarded
	$Button.connect("pressed",self,"changeScene")
# warning-ignore:unused_argumen
	
			
func change_level(lvl_number):
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/leve" + String(lvl_number) + ".tscn")
	
func changeScene():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/shop.tscn")
