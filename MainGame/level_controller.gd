extends Node2D

var firelink_scene = str("res://MainGame/Map/Levels/firelink.tscn")
var swamp_scene = str("res://MainGame/Map/Levels/swamp_procgen.tscn")

func _ready() -> void:
	get_tree().change_scene_to_file(firelink_scene)
