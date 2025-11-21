class_name Board
extends CanvasLayer

signal mine_pressed
signal empty_cell_pressed(flagged: bool)
signal flag_toggled(flagged: bool)

@export var mine_cell_scene: PackedScene
@export var empty_cell_scene: PackedScene

var _grid_container: GridContainer

var _grid: Array

var _rows: int
var _columns: int
var _mines: int

const _DIRECTIONS = [-1, 0, 1]

func initialize(rows: int, columns: int, mines: int) -> void:
	assert(rows * columns >= mines, "Attempted to initialize a board with more mines than available cells.")
	
	_rows = rows
	_columns = columns
	_mines = mines
	_grid_container = GridContainer.new()
	_grid_container.columns = _columns

	_generate_random_grid()

	%PanelContainer.add_child(_grid_container)

func reset() -> void:
	_grid = []

	var children = _grid_container.get_children()
	for c in children:
		_grid_container.remove_child(c)
		c.queue_free()

	_generate_random_grid()

func display_win() -> void:
	for row in _grid.size():
		for column in _grid[0].size():
			var cell: Cell = _grid[row][column]

			if cell is MineCell and not cell.flagged:
				cell.toggle_flag()

func display_loss() -> void:
	for row in _grid.size():
		for column in _grid[0].size():
			var cell: Cell = _grid[row][column]

			if cell is EmptyCell and cell.flagged:
				(cell as EmptyCell).reveal_incorrect_flag()

			if cell is MineCell and not cell.is_pressed and not cell.flagged:
				(cell as MineCell).reveal()

func _generate_random_grid() -> void:
	_randomize_grid()

	for row in _grid.size():
		for column in _grid[0].size():
			var cell: Cell = _grid[row][column]

			cell.connect("flag_toggled", _on_cell_flag_toggled)

			if cell is EmptyCell:
				_setup_empty_cell(cell, row, column)

			_grid_container.add_child(cell)

func _randomize_grid() -> void:
	var flat_grid = []
	var _mines_to_place = _mines

	for row in _rows:
		for column in _columns:
			if (_mines_to_place > 0):
				var mine_cell = _setup_mine_cell()

				flat_grid.append(mine_cell)

				_mines_to_place -= 1
			else:
				var empty_cell = empty_cell_scene.instantiate()

				flat_grid.append(empty_cell)

	flat_grid.shuffle()

	var index = 0

	for row in _rows:
		_grid.append([])

		for column in _columns:
			_grid[row].append(flat_grid[index])
			
			index += 1
	
	for row in _rows:
		for column in _columns:
			var cell: Cell = _grid[row][column]

			if cell is EmptyCell:
				for i in _DIRECTIONS:
					for j in _DIRECTIONS:
						if _is_outside_grid(row + i, column + j) or (i == 0 and j == 0):
							continue
						
						(cell as EmptyCell).surrounding_cells.append((_grid[row + i][column + j] as Cell))

func _setup_mine_cell() -> MineCell:
	var mine_cell = mine_cell_scene.instantiate()

	mine_cell.connect("pressed", _on_mine_cell_pressed)

	return mine_cell

func _setup_empty_cell(empty_cell: EmptyCell, row: int, column: int) -> void:
	var value := 0

	for i in _DIRECTIONS:
		for j in _DIRECTIONS:
			if _is_outside_grid(row + i, column + j):
				continue

			if _grid[row + i][column + j] is MineCell:
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

func _on_cell_flag_toggled(flagged: bool) -> void:
	flag_toggled.emit(flagged)
	
func _on_mine_cell_pressed() -> void:
	mine_pressed.emit()

func _on_empty_cell_pressed(flagged, x: int, y: int, value: int) -> void:
	empty_cell_pressed.emit(flagged)

	if value != 0:
		return

	_propagate_press(x, y)
