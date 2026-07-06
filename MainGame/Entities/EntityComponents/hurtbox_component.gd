class_name HurtboxComponent
extends Area2D

@export var hp_component: HpComponent

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# idk if this code should be here or hitbox_component
#func damage(attack: FighterComponent):
	#if hp_component:
		#hp_component.damage(attack)
