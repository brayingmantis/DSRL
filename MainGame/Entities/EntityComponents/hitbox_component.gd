class_name HitboxComponent
extends Area2D

@export var hp_component: HpComponent

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
#@onready var animation_player: AnimationPlayer = $AnimationPlayer

# idk if this code should be here or hurtbox_component
func damage(attack: FighterComponent):
	if hp_component:
		hp_component.damage(attack)


func _on_hurtbox_component_area_entered(area: Area2D) -> void:
	ActionsComponent.new()._melee_action(area) # deal damage
