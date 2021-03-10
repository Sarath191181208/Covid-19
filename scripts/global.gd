extends Node
var coins = 0
var  ammo = 0
var shield = false
var levels = []
var unlocked_levels = 1

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
	{"Name": "MadDoctor","Emotion" : "Happy","Text" : "Hey there i am a doctor "},
	{"Name": "MadDoctor","Emotion" : "Happy","Text" : "Let me tell you everyone says i am maddd!!!! hahahha i "},
	{"Name": "MadDoctor","Emotion" : "Happy","Text" : "asklgjasklg"},
	{"Name": "Doctor","Emotion" : "Happy","Text" : "hey"}
],
[
	{"Name": "MadDoctor","Emotion" : "Happy","Text" : "Hey there  "},
	{"Name": "MadDoctor","Emotion" : "Happy","Text" : "Let me tell  "}
  ]
	]

func texture(name,expression):
	return dictionary[name+expression]
