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
			
# warning-ignore:unused_argument
func _physics_process(delta):
	_ready()
			
func change_level(lvl_number):
	print("changed" +  " " + lvl_number)
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/leve" + String(lvl_number) + ".tscn")
