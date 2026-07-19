extends Node2D
#class_name LevelController

const FIRELINK_SCENE_PATH: String = "res://MainGame/Map/Levels/firelink.tscn"
const SWAMP_SCENE_PATH: String = "res://MainGame/Map/Levels/swamp_procgen.tscn"

enum Level { FIRELINK, SWAMP }
var current_level_id: Level
var current_level: Node = null

func _ready() -> void:
	_load_firelink()

func _load_level(path: String) -> void:
	
	# unload previous level
	if current_level:
		current_level.queue_free()
	# load level
	ResourceLoader.load_threaded_request(path)
	var scene = ResourceLoader.load_threaded_get(path)
	current_level = scene.instantiate()
	add_child(current_level)
	#initialise TileMapLayers (for FOV)
	TileTypes.walls = current_level.get_node("WallsLayer")
	TileTypes.ground = current_level.get_node("GroundLayer")
	TileTypes.bg = current_level.get_node("BGLayer")
	TileTypes.fog = current_level.get_node("FogLayer")
	#initialise stair signals
	if current_level.has_signal("stairs_down_entered"):
		current_level.stairs_down_entered.connect(_on_stairs_down_entered)
	if current_level.has_signal("stairs_up_entered"):
		current_level.stairs_up_entered.connect(_on_stairs_up_entered)

func _load_firelink() -> void:
	_load_level(FIRELINK_SCENE_PATH)
	current_level_id = Level.FIRELINK
func _load_swamp() -> void:
	_load_level(SWAMP_SCENE_PATH)
	current_level_id = Level.SWAMP

func _on_stairs_down_entered() -> void:
	match current_level_id:
		Level.FIRELINK:
			_load_swamp()
		Level.SWAMP:
			_load_swamp()

func _on_stairs_up_entered() -> void: #
	match current_level_id:
		Level.FIRELINK:
			print("Would move up")
		Level.SWAMP:
			_load_firelink()
