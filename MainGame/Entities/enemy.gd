#class_name Enemy
extends CharacterBody2D

@export var resource: ai_resource

@onready var player = $"../Player"
@onready var hp_component: HpComponent = $HPComponent

var TILE_SIZE: Vector2 = ProjectSettings.get_setting("global/tile_size")

func _on_player_movement_action() -> void:
		#global_position += Vector2.UP * TILE_SIZE
		pass

func _on_hp_component_death() -> void:
	print("Enemy died")
	queue_free()
