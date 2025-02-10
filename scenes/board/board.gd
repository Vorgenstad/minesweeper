class_name Board
extends CanvasLayer

signal bomb_pressed

func _on_bomb_cell_pressed() -> void:
	bomb_pressed.emit()

func _on_empty_cell_pressed(value: int) -> void:
	print("Pressed cell with value: ", value)
