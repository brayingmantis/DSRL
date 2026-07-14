extends Node2D

signal stairs_down_entered
signal stairs_up_entered

func _on_stairs_down_stairs_entered() -> void:
	stairs_down_entered.emit()


func _on_stairs_up_stairs_entered() -> void:
	stairs_up_entered.emit()
