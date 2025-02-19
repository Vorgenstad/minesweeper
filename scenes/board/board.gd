class_name Board
extends CanvasLayer

signal bomb_pressed

@export var bomb_cell_scene: PackedScene
@export var empty_cell_scene: PackedScene

var _grid: Array

const _DIRECTIONS = [-1, 0, 1]

func generate(rows: int, columns: int, bombs: int) -> void:
	_generate_random_grid(rows, columns, bombs)

	var grid_container = GridContainer.new()

	grid_container.columns = columns

	_insert_grid_into_container(grid_container)

	%PanelContainer.add_child(grid_container)

func _generate_random_grid(rows: int, columns: int, bombs: int) -> void:
	var flat_grid = []

	for row in rows:
		for column in columns:
			if (bombs > 0):
				var bomb_cell = _setup_bomb_cell()

				flat_grid.append(bomb_cell)

				bombs -= 1
			else:
				var empty_cell = empty_cell_scene.instantiate()

				flat_grid.append(empty_cell)

	flat_grid.shuffle()

	var index = 0

	for row in rows:
		_grid.append([])

		for column in columns:
			_grid[row].append(flat_grid[index])
			
			index += 1

func _setup_bomb_cell() -> BombCell:
	var bomb_cell = bomb_cell_scene.instantiate()

	bomb_cell.connect("pressed", _on_bomb_cell_pressed)

	return bomb_cell

func _insert_grid_into_container(grid_container: GridContainer) -> void:
	for row in _grid.size():
		for column in _grid[0].size():
			var cell: Cell = _grid[row][column]

			if cell is EmptyCell:
				_setup_empty_cell(cell, row, column)

			grid_container.add_child(cell)

func _setup_empty_cell(empty_cell: EmptyCell, row: int, column: int) -> void:
	var value := 0

	for i in _DIRECTIONS:
		for j in _DIRECTIONS:
			if _is_outside_grid(row + i, column + j):
				continue

			if _grid[row + i][column + j] is BombCell:
				value += 1
	
	empty_cell.value = value

	empty_cell.connect("pressed", _on_empty_cell_pressed.bind(row, column, value))

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
