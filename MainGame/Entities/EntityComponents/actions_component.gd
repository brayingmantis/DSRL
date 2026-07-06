class_name ActionsComponent
extends Node

signal melee_action

func _ready() -> void:
	melee_action.connect(_melee_action)

func _melee_action(area: Area2D) -> void:
	if area is HitboxComponent: 
		var attack = FighterComponent.new()
		var weapon_damage = 1 # change later
		attack.attack_damage = 0 + weapon_damage
		#attack.knockback = 0 # + weapon knockback
		#attack.attack_pos = global_position
		area.damage(attack) # deal damage
		
		emit_signal("melee_action")
