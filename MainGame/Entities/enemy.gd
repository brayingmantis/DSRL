#class_name Enemy
extends CharacterBody2D

#@export var resource: ai_resource
@export var HPBar: HPBar

@onready var player = $"../Player"
@onready var hp_component: HpComponent = $HPComponent

var TILE_SIZE: Vector2 = ProjectSettings.get_setting("global/tile_size")

func _ready() -> void:
	HPBar._setup_hp_bar(hp_component.hp)

func _on_player_movement_action() -> void:
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
