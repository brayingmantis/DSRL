extends Node2D

class_name swamp
#@export var colour = Color.REBECCA_PURPLE

@export var noise_height_texture: NoiseTexture2D

var noise: Noise
var width: int = 60
var height: int = 120

@onready var tilemap_ground = $TileMapLayer_ground
@onready var tilemap_poison = $TileMapLayer_poison

var source_id = 0 
var ground_atlas = Vector2i(7, 0)
var poison_atlas = Vector2i(8, 2)
var web_atlas = Vector2i(2, 15)

func _ready() -> void:
	noise = noise_height_texture.noise
	generate_world()
	
	# if stairs up/down signal received, map to the appropriate area

func generate_world():
	noise.set_seed(randi_range(0, 1000))
	print("Swamp seed: ", noise.seed)
	for x in range(-width/2, width/2): # would just be width and height in the brackets respectively,
		for y in range(-height/2, height/2): # (cont.) but that generates everything at (0,0), which is top-left.
			var noise_val: float = noise.get_noise_2d(x,y)
			if noise_val >= 0.0:
				tilemap_ground.set_cell(Vector2(x, y), source_id, ground_atlas)
			elif noise_val < 0.0:
				tilemap_poison.set_cell(Vector2(x, y), source_id, poison_atlas)
	# spawn tile which gives a signal when interacted with to move to next area (stairs signal)
	# could use scene tile perhaps? as long as I can link the areas individually
