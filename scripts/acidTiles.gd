extends Node2D

func _on_acidTiles_body_entered(body):
	print('sldkfj')
	for i in $image.get_children():
		print('sldkfj')
		i.self_modulate = 'ff0000'

#
#func _on_acidTiles_area_entered(area):
#	print('sldkfj')
#	for i in $image.get_children():
#		print('sldkfj')
#		i.self_modulate = 'ff0000'
