extends Node2D
#class_name LevelController

const FIRELINK_SCENE_PATH: String = "res://MainGame/Map/Levels/firelink.tscn"
const SWAMP_SCENE_PATH: String = "res://MainGame/Map/Levels/swamp_procgen.tscn"

var current_level: Node = null

var is_in_swamp = false # temp variable

func _ready() -> void:
	_load_firelink()

func _load_level(path: String) -> void:
	if current_level:
		current_level.queue_free()
	
	ResourceLoader.load_threaded_request(path)
	var scene = ResourceLoader.load_threaded_get(path)
	current_level = scene.instantiate()
	add_child(current_level)

func _load_firelink() -> void:
	_load_level(FIRELINK_SCENE_PATH)

func _load_swamp() -> void:
	_load_level(SWAMP_SCENE_PATH)

func _on_stairs_down_stairs_entered() -> void: # quick way to move between two levels
	if is_in_swamp:
		_load_firelink()
		is_in_swamp = false
	else:
		_load_swamp()
		is_in_swamp = true
