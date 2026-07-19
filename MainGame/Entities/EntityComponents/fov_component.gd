extends Node
class_name FOVComponent

enum TileVisibility { UNSEEN, PREVIOUSLY_SEEN, CURRENTLY_SEEN }

@export var radius: int = 8
@export var fog_layer: TileMapLayer = TileTypes.fog
@export var wall_layer: TileMapLayer = TileTypes.walls
@export var ground_layer: TileMapLayer = TileTypes.ground
@export var bg_layer: TileMapLayer = TileTypes.bg

# stores visibility state for every tile that has ever been seen
var visibility_map: Dictionary = {}  # Vector2i -> TileVisibility

func update_fov(player_tile: Vector2i) -> void:
	_clear_current_vision()
	_compute_fov(player_tile)
	_apply_visibility()

func _clear_current_vision() -> void:
	for tile in visibility_map:
		if visibility_map[tile] == TileVisibility.CURRENTLY_SEEN:
			visibility_map[tile] = TileVisibility.PREVIOUSLY_SEEN

func _apply_visibility() -> void:
	for tile in visibility_map:
		var visibility_state = visibility_map[tile]
		match visibility_state:
			TileVisibility.UNSEEN:
				TileTypes.fog.set_cell(tile, 0, Vector2i(12, 20)) # black
			TileVisibility.PREVIOUSLY_SEEN:
				TileTypes.fog.set_cell(tile, 0, Vector2i(9, 20))  # dark grey
			TileVisibility.CURRENTLY_SEEN:
				TileTypes.fog.erase_cell(tile) # remove fog

func _set_tile_modulate(tile: Vector2i, color: Color) -> void:
	# apply to all layers so they stay in sync
	ground_layer.set_cell_modulate(tile, color) 
	bg_layer.set_cell_modulate(tile, color)
	wall_layer.set_cell_modulate(tile, color)

# GO THROUGH THIS LOL

func _compute_fov(origin: Vector2i) -> void:
	# always mark the player's tile as visible
	visibility_map[origin] = TileVisibility.CURRENTLY_SEEN
	
	# run shadowcast for all 8 octants
	for octant in range(8):
		_cast_light(origin, radius, 1, 1.0, 0.0, octant)

func _is_opaque(tile: Vector2i) -> bool:
	return wall_layer.get_cell_source_id(tile) != -1

func _cast_light(origin: Vector2i, max_radius: int, row: int, start_slope: float, end_slope: float, octant: int) -> void:
	
	if start_slope < end_slope:
		return
		
	var next_start_slope = start_slope
	
	for i in range(row, max_radius + 1):
		var blocked = false
		
		for j in range(-i, 1):
			var l_slope = (j - 0.5) / (i + 0.5)
			var r_slope = (j + 0.5) / (i - 0.5)
			
			if start_slope < r_slope:
				continue
			elif end_slope > l_slope:
				break
			
			var tile = _octant_transform(origin, i, j, octant)
			
			if _in_radius(origin, tile, max_radius):
				visibility_map[tile] = TileVisibility.CURRENTLY_SEEN
			
			if blocked:
				if _is_opaque(tile):
					next_start_slope = r_slope
					continue
				else:
					blocked = false
					start_slope = next_start_slope
			elif _is_opaque(tile):
				blocked = true
				next_start_slope = r_slope
				_cast_light(origin, max_radius, i + 1, start_slope, l_slope, octant)
		
		if blocked:
			break

func _octant_transform(origin: Vector2i, row: int, col: int, octant: int) -> Vector2i:
	var dx: int
	var dy: int
	match octant:
		0: dx = col;  dy = -row
		1: dx = row;  dy = -col
		2: dx = row;  dy = col
		3: dx = col;  dy = row
		4: dx = -col; dy = row
		5: dx = -row; dy = col
		6: dx = -row; dy = -col
		7: dx = -col; dy = -row
	return Vector2i(origin.x + dx, origin.y + dy)

func _in_radius(origin: Vector2i, tile: Vector2i, max_radius: int) -> bool:
	var dx = tile.x - origin.x
	var dy = tile.y - origin.y
	return dx * dx + dy * dy <= max_radius * max_radius
