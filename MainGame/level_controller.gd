extends Node2D
#class_name LevelController

const FIRELINK_SCENE: String = "res://MainGame/Map/Levels/firelink.tscn"
const SWAMP_SCENE: String = "res://MainGame/Map/Levels/swamp_procgen.tscn"
const ASYLUM_SCENE: String = "res://MainGame/Map/Levels/asylum_procgen.tscn"

enum Level { FIRELINK, SWAMP, ASYLUM, }
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
	# Tiles
	LevelRefs.walls = current_level.get_node("WallLayer")
	LevelRefs.ground = current_level.get_node("GroundLayer")
	LevelRefs.fog = current_level.get_node("FogLayer")
	# initialise TileMapLayers (for FOV)
	#LevelRefs.walls = current_level.get_node("WallsLayer")
	#LevelRefs.ground = current_level.get_node("GroundLayer")
	#LevelRefs.bg = current_level.get_node("BGLayer")
	#LevelRefs.fog = current_level.get_node("FogLayer")
	# spawn enemies after LevelRefs is populated
	if current_level.has_node("EnemySpawner"):
		var spawner = current_level.get_node("EnemySpawner")
		call_deferred("_spawn_after_ready", spawner)
	# initialise stair signals
	if current_level.has_signal("stairs_down_entered"):
		current_level.stairs_down_entered.connect(_on_stairs_down_entered)
	if current_level.has_signal("stairs_up_entered"):
		current_level.stairs_up_entered.connect(_on_stairs_up_entered)

func _spawn_after_ready(spawner: Node) -> void:
	spawner.spawn_enemies(LevelRefs.player, LevelRefs.walls)

func _load_firelink() -> void:
	_load_level(FIRELINK_SCENE)
	current_level_id = Level.FIRELINK
func _load_asylum() -> void:
	_load_level(ASYLUM_SCENE)
	current_level_id = Level.ASYLUM
func _load_swamp() -> void:
	_load_level(SWAMP_SCENE)
	current_level_id = Level.SWAMP


func _on_stairs_up_entered() -> void:
	match current_level_id:
		Level.FIRELINK: 
			_load_asylum() # firelink -> asylum
		Level.ASYLUM: 
			pass # asylum -> 
		Level.SWAMP: # swamp -> firelink
			_load_firelink()

func _on_stairs_down_entered() -> void:
	match current_level_id:
		Level.FIRELINK: 
			_load_swamp() # firelink -> swamp
		Level.ASYLUM: 
			_load_firelink() # asylum -> firelink
		Level.SWAMP:
			_load_swamp() # swamp -> 
