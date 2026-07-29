extends Node2D

class_name asylum

@onready var tilemap_ground = $TileMapLayer_ground
@onready var tilemap_walls = $TileMapLayer_walls

@export_category("Level Dimensions")
var width: int = 120
var height: int = 60

@export_category("Rooms RNG")
@export var max_rooms: int = 50
@export var room_max_size: int = 20
@export var room_min_size: int = 5

var source_id = 0
var wall_atlas = Vector2i(23, 16)
var ground_atlas = Vector2i(12, 20)

var _rng: = RandomNumberGenerator.new()

@onready var seed = Game.new().seed

signal stairs_down_entered
signal stairs_up_entered

func _on_stairs_down_stairs_entered() -> void:
	stairs_down_entered.emit()

func _on_stairs_up_stairs_entered() -> void:
	stairs_up_entered.emit()

func _ready() -> void:
	_rng.randomize()
	_generate_level()

	# if stairs up/down signal received, map to the appropriate area

func _generate_level():
	print("Asylum seed: ", seed)
	
	var rooms: Array[Rect2i] = []
	
	for _try_room in max_rooms:
		var room_width: int = _rng.randi_range(room_min_size, room_max_size)
		var room_height: int = _rng.randi_range(room_min_size, room_max_size)
		
		var x: int = _rng.randi_range(0, width - room_width - 1)
		var y: int = _rng.randi_range(0, height - room_height - 1)
		
		var new_room: = Rect2i(x, y, room_width, room_height)
		
		var has_intersections: = false # disallow overlapping rooms
		for room in rooms:
			# Rect2i.intersects() checks for overlapping points. In order to allow bordering rooms one room is shrunk.
			if room.intersects(new_room.grow(-1)):
				has_intersections = true
				break
		if has_intersections:
			continue
	
		_carve_room(new_room)
		
		if rooms.is_empty():
			# player.position = new_room.get_center()
			pass
		else:
			_tunnel_between(rooms.back().get_center(), new_room.get_center())
		
		rooms.append(new_room)

func _carve_room(room: Rect2i) -> void:
	var inner: Rect2i = room.grow(-1)
	for y in range(inner.position.y, inner.end.y + 1):
		for x in range(inner.position.x, inner.end.x + 1):
			tilemap_ground.set_cell(Vector2(x, y), source_id, ground_atlas)

func _tunnel_horizontal(y: int, x_start: int, x_end: int) -> void:
	var x_min: int = mini(x_start, x_end)
	var x_max: int = maxi(x_start, x_end)
	for x in range(x_min, x_max + 1):
		tilemap_ground.set_cell(Vector2(x, y), source_id, ground_atlas)
		

func _tunnel_vertical(x: int, y_start: int, y_end: int) -> void:
	var y_min: int = mini(y_start, y_end)
	var y_max: int = maxi(y_start, y_end)
	for y in range(y_min, y_max + 1):
		tilemap_ground.set_cell(Vector2(x, y), source_id, ground_atlas)

func _tunnel_between(start: Vector2i, end: Vector2i) -> void:
	if _rng.randf() < 0.5:
		_tunnel_horizontal(start.y, start.x, end.x)
		_tunnel_vertical(end.x, start.y, end.y)
	else:
		_tunnel_vertical(start.x, start.y, end.y)
		_tunnel_horizontal(end.y, start.x, end.x)


#func _carve_tile(x: int, y: int) -> void:
	#var tile_pos = Vector2i(x, y)
	#var tile = asylum.get_tile(tile_pos)
	
