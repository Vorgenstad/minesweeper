class_name Board
extends CanvasLayer

signal bomb_pressed

func _on_bomb_cell_pressed() -> void:
	bomb_pressed.emit()
