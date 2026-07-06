extends Node2D

func _ready() -> void:
	#print("I am raycast of: ", get_path())
	pass

# detect if there is a collision shape
# if so, disallow movement to that tile
# if HpComponent present, deal damage
