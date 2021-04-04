extends Node2D

const TRANS = Tween.TRANS_SINE
const EASE = Tween.EASE_IN_OUT

var y = 1
var priority = 0
var amplitude = 0 
onready var camera = get_parent()

# warning-ignore:shadowed_variable
# warning-ignore:shadowed_variable
func shake(duration = 0.2, priority = 0 , frequency = 20, amplitude = 5):
	if y == 0:
		frequency -= 5
	if priority >= self.priority:
		self.priority = priority
		self.amplitude = amplitude
		$Duration.wait_time = duration
		$Frequency.wait_time = 1/float(frequency)
		$Duration.start()
		$Frequency.start()
		_new_shake()
func _new_shake():
	var rand = Vector2()
	if y == 0 :
		rand.x = amplitude
		rand.y  = 0 
		y = 1
	else:
		rand.x = rand_range(-amplitude,amplitude)
		rand.y = rand_range(-amplitude,amplitude) 

		
	$ShakeTween.interpolate_property(camera,"offset",camera.offset,rand,$Frequency.wait_time,TRANS,EASE)
	$ShakeTween.start()
func _reset():
		$ShakeTween.interpolate_property(camera,"offset",camera.offset,Vector2(),$Frequency.wait_time,TRANS,EASE)
		$ShakeTween.start()
		priority = 0

func _on_Frequency_timeout():
	_new_shake()



func _on_Duration_timeout():
	_reset()
	$Frequency.stop()
