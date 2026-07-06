extends Node2D
class_name HpComponent

signal hp_changed(current: float, max: float)
signal death

@export var max_hp: int = 10
@export var hp: int

func _ready() -> void:
	hp = max_hp
	_emit()

func damage(attack: FighterComponent):
	hp -= attack.attack_damage
	#hp -= amount
	_emit()
	if hp <= 0:
		death.emit()

func heal(amount: int) -> void:
	hp = clamp(hp + amount, 0, max_hp)
	_emit()

func _emit():
	hp_changed.emit(hp, max_hp)
	
	var parent = get_parent()
	print(parent, " HP: %d / %d" % [hp, max_hp])
