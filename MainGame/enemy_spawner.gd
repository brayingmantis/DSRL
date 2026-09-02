extends Node2D
class_name EnemySpawner

const ENEMY_SCENE = preload("res://MainGame/Entities/enemy.tscn")

@export var spawn_points: Array[Vector2i] = []  # set in editor per level

func spawn_enemies(player: CharacterBody2D, walls: TileMapLayer) -> void:
	for tile in spawn_points:
		var enemy = ENEMY_SCENE.instantiate()
		add_child(enemy)
		enemy.global_position = Vector2(tile) * Vector2(walls.tile_set.tile_size)
		enemy.initialise(player, walls)

# LevelController then spawns enemies
