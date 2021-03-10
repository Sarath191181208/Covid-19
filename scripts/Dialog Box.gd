extends ColorRect
var Dialog = []
var Dialog_no = 0
export(float) var textSpeed = 0.05
var next = 0 
var dialog
var phraseNum = 0
var finished = false
 
func _ready():
	Dialog_no = int(get_tree().current_scene.name) -1
	Dialog = Global.Dialogs[Dialog_no]
	get_tree().paused = true
	$Timer.wait_time = textSpeed
	dialog = getDialog()
	nextPhrase()
func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		if finished:
			nextPhrase()
		else:
			$Text.visible_characters = len($Text.text)
 
func getDialog() -> Array:

	if typeof(Dialog) == TYPE_ARRAY:
		return Dialog
	else:
		return []
 
func nextPhrase() -> void:
	if phraseNum >= len(dialog):
		queue_free()
		get_tree().paused = false
		return
	
	finished = false
	
	$Name.bbcode_text = dialog[phraseNum]["Name"]
	$Text.bbcode_text = dialog[phraseNum]["Text"]
	
	$Text.visible_characters = 0
	$Portrait.texture = Global.texture(dialog[phraseNum]["Name"], dialog[phraseNum]["Emotion"])
#	var f = File.new()
#	var img = "res://" + dialog[phraseNum]["Name"] + dialog[phraseNum]["Emotion"] + ".png"
#	$Label.text = String(img)
#	if f.file_exists(img):
#		$Portrait.texture = load(img)
#
#	else: $Portrait.texture = null
#
	while $Text.visible_characters < len($Text.text):
		$Text.visible_characters += 1
		
		$Timer.start()
		yield($Timer, "timeout")
	
	finished = true
	phraseNum += 1
	return
