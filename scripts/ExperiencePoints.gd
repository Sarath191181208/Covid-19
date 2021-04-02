extends StaticBody2D
var Text 
func _ready():
	$Label.text = Text
func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
	
func text(text):
	Text = "+" + String(text)
