extends TouchScreenButton
# Change these based on the size of your button and outer sprite
var radius = Vector2(16, 16)
var boundary = 32
export(int) var limit = 5
var ongoing_drag = -1

# warning-ignore:unused_argument
func _process(delta):
	if get_button_pos().length() > limit:
		Global.dragging = true
	else:
		Global.dragging = false
	if ongoing_drag == -1:
		$Tween.interpolate_property(self,"position",position,Vector2(-16,-16),0.5,Tween.TRANS_EXPO,Tween.EASE_OUT)
		$Tween.start()


func get_button_pos():
	return position + radius

func _input(event):
	if event is InputEventScreenDrag and get_button_pos().length() > limit: 
		action = ""
	else:
		action = "fire"
	if event is InputEventScreenDrag or (event is InputEventScreenTouch and event.is_pressed()):
		if get_button_pos().length() > limit:
			action = ""
		else:
			Global.dragging = false
		var event_dist_from_centre = (event.position - get_parent().global_position).length()
		if event_dist_from_centre <= boundary * global_scale.x or event.get_index() == ongoing_drag:
			set_global_position(event.position - radius * global_scale)
# constraints
			if get_button_pos().length() > boundary:
				set_position( get_button_pos().normalized() * boundary - radius)
			ongoing_drag = event.get_index()
#drag of  an other finger
	if event is InputEventScreenTouch and !event.is_pressed() and event.get_index() == ongoing_drag:
		ongoing_drag = -1
	

