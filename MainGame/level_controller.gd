extends Node2D
class_name LevelController

const FIRELINK_SCENE_PATH: String = "res://MainGame/Map/Levels/firelink.tscn"
const SWAMP_SCENE_PATH: String = "res://MainGame/Map/Levels/swamp_procgen.tscn"

func _ready() -> void:
	_load_firelink()

func _load_firelink() -> void:
	ResourceLoader.load_threaded_request(FIRELINK_SCENE_PATH)
	var firelink = ResourceLoader.load_threaded_get(FIRELINK_SCENE_PATH)
	var load_firelink = firelink.instantiate()
	add_child(load_firelink)

func _load_swamp() -> void:
	ResourceLoader.load_threaded_request(SWAMP_SCENE_PATH)
	var swamp = ResourceLoader.load_threaded_get(SWAMP_SCENE_PATH)
	var load_swamp = swamp.instantiate()
	add_child(load_swamp)


func _on_stairs_down_stairs_entered() -> void:
	# remove previous scene
	_load_swamp()
