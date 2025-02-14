class_name Board
extends CanvasLayer

signal bomb_pressed

var _grid: Array

const _DIRECTIONS = [-1, 0, 1]

func _ready() -> void:
	# TODO: Generate board and populate the grid
	_grid = [[], [], [], [], [], []]

	var cells := %GridContainer.get_children()

	for x in 6:
		for y in 10:
			var cell: Cell = cells.pop_front()

			if cell is EmptyCell:
				cell.connect("pressed", _on_empty_cell_pressed.bind(x, y, cell.value))

			_grid[x].append(cell)

func _propagate_press(x: int, y: int) -> void:
	for i in _DIRECTIONS:
		for j in _DIRECTIONS:
			if _is_outside_grid(x + i, y + j):
				continue
			
			var cell: Cell = _grid[x + i][y + j]

			if cell is EmptyCell and !cell.is_pressed:
				cell.press()

func _is_outside_grid(x: int, y: int) -> bool:
	return x < 0 or x >= _grid.size() or y < 0 or y >= _grid[0].size()

func _on_bomb_cell_pressed() -> void:
	bomb_pressed.emit()

func _on_empty_cell_pressed(x: int, y: int, value: int) -> void:
	if value != 0:
		return
	
	_propagate_press(x, y)
