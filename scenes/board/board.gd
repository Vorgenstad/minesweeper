class_name Board
extends CanvasLayer

signal bomb_pressed

var _grid: Array

func _ready() -> void:
	# TODO: Generate board and populate the grid
	_grid = [[], [], [], [], [], []]

	var cells := %GridContainer.get_children()

	var index = 0

	for row in _grid:
		row.append(cells.slice(index, index + 10))

		index += 10

func _on_bomb_cell_pressed() -> void:
	bomb_pressed.emit()

func _on_empty_cell_pressed(value: int) -> void:
	print("Pressed cell with value: ", value)
