extends Node2D

@onready var area_2d: Area2D = $Area2D

signal stairs_entered

func _ready() -> void:
	stairs_entered.connect(_on_area_2d_area_entered)
	#pass

func _on_area_2d_area_entered(area: Area2D) -> void:
	emit_signal("stairs_entered")
