extends CanvasLayer
signal coins_zero
var coins = 1

func _ready():
	$number_of_coins_collected.text = String(coins)

func _on_coin_coin_collected():
	coins += 1
	_ready()


func _on_player_fired():
	if coins != 0 :
		coins -= 1
		_ready()
	else :
		emit_signal("coins_zero")
