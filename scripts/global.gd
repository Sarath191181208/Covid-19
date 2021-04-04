extends Node

export (Script) var game_save_class = load("res://game_save.gd")
var save_vars = ['coins','levels','collected','unlocked_levels',"boomerang","experience","expLevel"]

var  ammo = 0
var shield = false


var coins = 0
var levels = []
var collected = {}
var unlocked_levels = 1
var boomerang = false
var experience = 0 
var expLevel = 0

var PlayeHappy = load("res://Assets/dialogs/PlayerHappy.png")
var DoctorHappy = load("res://Assets/dialogs/DoctorHappy.png")
var MadDoctorHappy = load("res://Assets/dialogs/MadDoctorHappy.png")

var dictionary = {
	"DoctorHappy" : DoctorHappy,
	"MadDoctorHappy" : MadDoctorHappy,
	"PlayerHappy" : PlayeHappy
}

var Dialogs = [
	[
		{"Name": "Player","Emotion" : "Happy","Text" : "Where am I ?"},
	{"Name": "MadDoctor","Emotion" : "Happy","Text" : "Hey there i am a doctor working in a laboratory . You are in my lab "},
	{"Name": "MadDoctor","Emotion" : "Happy","Text" : "I didnt like the way the humans keep themselves"},
	{"Name": "Player","Emotion" : "Happy","Text" : " So?"},
	{"Name": "MadDoctor","Emotion" : "Happy","Text" : "hahahh ! I mutated the corona virus into a deadly zombie virus"},
	{"Name": "Player","Emotion" : "Happy","Text" : "What?"},
	{"Name": "Player","Emotion" : "Happy","Text" : "Why am I even here ?"},
	{"Name": "MadDoctor","Emotion" : "Happy","Text" : "Thats for you to figure out"},
	{"Name": "Doctor","Emotion" : "Happy","Text" : "Hey there are you really human! "},
	{"Name": "Player","Emotion" : "Happy","Text" : "Yeah"},
	{"Name": "Doctor","Emotion" : "Happy","Text" : "So you must be following the directions correctly"},
	{"Name": "Player","Emotion" : "Happy","Text" : "Yeah"},
	{"Name": "Doctor","Emotion" : "Happy","Text" : "Only you remain in this world to save it. Even tough this new virus is deadly it inherits characteristics of corona "},
	{"Name": "Doctor","Emotion" : "Happy","Text" : "There is a cure to this virus "},
	{"Name": "Player","Emotion" : "Happy","Text" : "Tell me how to get it"},
	{"Name": "Doctor","Emotion" : "Happy","Text" : "Not so fast , but you have to get into the upper floor of doctors lab"},
	{"Name": "Player","Emotion" : "Happy","Text" : " Ok Tell me how to get there"},
	{"Name": "Doctor","Emotion" : "Happy","Text" : "The button you see on left are to control movement you can use -> or <- arrow keys"},
	{"Name": "Doctor","Emotion" : "Happy","Text" : "You can shoot using the button on bottom right or using space"},
	{"Name": "Doctor","Emotion" : "Happy","Text" : "You can jump using the upper button on right side of screen or use up arrow key"},
	{"Name": "Doctor","Emotion" : "Happy","Text" : "Collect coins they are quite useful in helping you to buy sanitiser(attacks)"},
	{"Name": "Doctor","Emotion" : "Happy","Text" : "If you need any help come to my medical store I can provide you with some upgrades using coins"},
	{"Name": "Doctor","Emotion" : "Happy","Text" : "This room is filled with virus you will be infected too if you remain in a certain room for too long "},
	{"Name": "Doctor","Emotion" : "Happy","Text" : "See you later if you remain "},
	{"Name": "Player","Emotion" : "Happy","Text" : "What ???"},
],
#level 1 story ends
[
	{"Name": "MadDoctor","Emotion" : "Happy","Text" : "Where are all my money"},
		{"Name": "MadDoctor","Emotion" : "Happy","Text" : "Stupid Zombies might have picked them up and would have dropped them"},
	{"Name": "Doctor","Emotion" : "Happy","Text" : "Hey there you are doing well , The MadDoctor is trying to keep you away from his final floor"}
	,{"Name": "Doctor","Emotion" : "Happy","Text" : "He is experimenting with new animals and materials be aware !"},
	{"Name": "Doctor","Emotion" : "Happy","Text" : "Zombies drop some containers in a level which can only be found in first try so dont lose !!"},
	{"Name": "Doctor","Emotion" : "Happy","Text" : "See a Zombie dropped a box you can collect it and answer a question to get coins"}
  ],
#level 2 story ends
[
{"Name": "Doctor","Emotion" : "Happy","Text" : "Hey there I hope you are doing well ? "},
{"Name": "Doctor","Emotion" : "Happy","Text" : "Let me tell you that doofus had succeded in creating a tank he is using it to stop you BEWARE !!! "},
{"Name": "Doctor","Emotion" : "Happy","Text" : "If you hit the tank you will die"}
],
#level 3 story ends
[
{"Name": "Doctor","Emotion" : "Happy","Text" : "Hey there I hope you are doing well ? "},
{"Name": "Doctor","Emotion" : "Happy","Text" : "The docotor is trying to make a  wild bird beware"}
],
#level 4 story ends
[
{"Name": "MadDoctor","Emotion" : "Happy","Text" : "Hey there  "},
{"Name": "MadDoctor","Emotion" : "Happy","Text" : "Let me tell  "}
],
#level 5 story ends
[
{"Name": "MadDoctor","Emotion" : "Happy","Text" : "Hey there  "},
{"Name": "MadDoctor","Emotion" : "Happy","Text" : "Let me tell  "}
],
#level 6 story ends
[
{"Name": "MadDoctor","Emotion" : "Happy","Text" : "Hey there  "},
{"Name": "MadDoctor","Emotion" : "Happy","Text" : "Let me tell  "}
],
#level 7 story ends
[
{"Name": "MadDoctor","Emotion" : "Happy","Text" : "Hey there  "},
{"Name": "MadDoctor","Emotion" : "Happy","Text" : "Let me tell  "}
]
	]

func texture(name,expression):
	if dictionary[name+expression] != null:
		return dictionary[name+expression]
	else :
		return null
		
func save(name):
	if int(name) in collected :
		return false
	else :
		collected[int(name)] = name
		return true
		

func _ready():
	if not load_world():
		coins = 0
		levels = []
		collected = {}
		unlocked_levels = 1
		boomerang = false
		experience = 0
		expLevel = 0

# warning-ignore:unused_argument
func _physics_process(delta):
	save_world()
#	var dir = Directory.new()
#	dir.remove("user://saves/save_01.tres")
		
func _on_Main_tree_exiting():
	save_world()
		
func save_world():
	var new_save = game_save_class.new()
	new_save.coins = coins
	new_save.levels = levels
	new_save.collected = collected
	new_save.unlocked_levels = unlocked_levels
	new_save.boomerang = boomerang
	new_save.experience = experience
	new_save.expLevel = expLevel
	var dir = Directory.new()
	if not dir.dir_exists("user://saves/"):
		dir.make_dir_recursive("user://saves/")
		
# warning-ignore:return_value_discarded
	ResourceSaver.save("user://saves/save_01.tres",new_save)


func verify_save(world_save):
	for v in save_vars :
		if world_save.get(v) == null :
			return false
	return true
	
func load_world():
	var dir = Directory.new()
	if not dir.file_exists("user://saves/save_01.tres"):
		return false
	var world_save = load("user://saves/save_01.tres")
	if not verify_save(world_save):
		return false
		
	
	coins = world_save.coins
	levels = world_save.levels
	collected = world_save.collected
	unlocked_levels = world_save.unlocked_levels
	boomerang = world_save.boomerang
	experience = world_save.experience
	expLevel = world_save.expLevel
	
	return true


