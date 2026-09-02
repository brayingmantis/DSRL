#class_name Enemy
extends CharacterBody2D

var TILE_SIZE: Vector2 = ProjectSettings.get_setting("global/tile_size")
const TILE_SIZE_FLOAT: float = 16

@export var turns_to_move: int = 1
@export var resource: ai_resource
@export var HPBar: HPBar

@export_category("Pathfinding setup") # these are overridden in _ready()
@export var wall_layer: TileMapLayer = null
@export var ground_layer: TileMapLayer = null
@export var player_node: CharacterBody2D = null
@export var visual_path_line2D: Line2D = null # debug pathfinding line

@onready var hp_component: HpComponent = $HPComponent

var pathfinding_grid: AStarGrid2D = AStarGrid2D.new()
var path_to_player: Array = []
var turn_counter: int = 1

func _ready() -> void:
	if not wall_layer:
		var wall_layer = LevelRefs.walls
	if not ground_layer:
		var ground_player = LevelRefs.ground
	var player_node = null # set by initialise func

func initialise(player: CharacterBody2D, walls: TileMapLayer) -> void:
	player_node = player
	wall_layer = walls
	
	HPBar._setup_hp_bar(hp_component.hp)
	player_node.player_action.connect(_move_ai)
	
	# AStarGrid pathfinding
	visual_path_line2D.global_position = Vector2(TILE_SIZE/2.0) # debug line goes from tile centre
	#pathfinding_grid.region = .get_used_rect() # may or may not work lol
	pathfinding_grid.cell_size = Vector2(TILE_SIZE)
	pathfinding_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ALWAYS # diagonal movement behaviour
	pathfinding_grid.update()
	# add collidable walls to pathfinding grid
	for cell in wall_layer.get_used_cells():
		pathfinding_grid.set_point_solid(cell, true)
		
		_move_ai()

func _move_ai():
	path_to_player = pathfinding_grid.get_point_path(global_position / TILE_SIZE_FLOAT, player_node.global_position / TILE_SIZE_FLOAT)
	visual_path_line2D.points = path_to_player
	
	if turn_counter != turns_to_move:
		turn_counter += 1
	else:
		if path_to_player.size() > 1: # if there is a destination
			path_to_player.remove_at(0) # remove entity's own position because we don't need it
			var go_to_pos = path_to_player[0] + Vector2(TILE_SIZE/2) 
			
			if go_to_pos.x != global_position.x:
				$Sprite2D.flip_h = false if go_to_pos.x > global_position.x else true # flip sprite
			
			global_position = go_to_pos
			
			visual_path_line2D.points = path_to_player
			
			turn_counter = 1

func _on_player_player_action() -> void:
	_on_player_action()

func _on_player_melee_action() -> void:
	_on_player_action()

func _on_player_action() -> void:
	#global_position += Vector2.UP * TILE_SIZE
	pass

func _on_hp_component_hp_changed(current: float, max: float) -> void:
	if not HPBar:
		return
	HPBar.change_value(current)

func _on_hp_component_death() -> void:
	print(self, " died")
	queue_free()
