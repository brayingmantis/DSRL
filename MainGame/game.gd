extends Node2D

class_name Game

var seed: int = randi_range(1, 1000)

func _ready() -> void:
	#RenderingServer.set_default_clear_color(bg_colour)
	
	#seed = randi_range(1, 1000)
	return
	print(seed)
	#pass
