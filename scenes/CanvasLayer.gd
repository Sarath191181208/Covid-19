extends CanvasLayer
var coins = 0

func _ready():
	$number_of_coins_collected.text = String(coins)
	

func _on_coin_coin_collected():
	coins += 1
	_ready()
