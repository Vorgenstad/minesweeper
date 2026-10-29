class_name Board
extends PanelContainer

signal mine_pressed
signal empty_cell_pressed(flagged: bool)
signal flag_toggled(flagged: bool)

const _DIRECTIONS = [-1, 0, 1]

@export var mine_cell_scene: PackedScene
@export var empty_cell_scene: PackedScene

var _grid_container: GridContainer

var _grid: Array[Array]

var _settings: GameSettings

var _started := false

func initialize(settings: GameSettings) -> void:
	_grid_container = GridContainer.new()
	_grid_container.columns = settings.columns

	_settings = settings

	_generate_initial_grid()

	add_child(_grid_container)

func reset() -> void:
	_started = false
	_clear_grid()
	_generate_initial_grid()

func display_win() -> void:
	print("You win")
	for row in _grid.size():
		for column in _grid[0].size():
			var cell: Cell = _grid[row][column]

			if cell is MineCell and not cell.flagged:
				cell.toggle_flag()

func display_loss() -> void:
	print("You lose")
	for row in _grid.size():
		for column in _grid[0].size():
			var cell: Cell = _grid[row][column]

			if cell is EmptyCell and cell.flagged:
				(cell as EmptyCell).reveal_incorrect_flag()

			if cell is MineCell and not cell.is_revealed and not cell.flagged:
				(cell as MineCell).reveal()

func _setup(empty_cell_x: int, empty_cell_y: int) -> void:
	assert(_settings.rows * _settings.columns >= _settings.mines,
		"Attempted to initialize a board with more mines than available cells.")

	_clear_grid()

	_randomize_grid()

	_grid[empty_cell_x][empty_cell_y] = empty_cell_scene.instantiate()

	for row in _grid.size():
		for column in _grid[0].size():
			var cell: Cell = _grid[row][column]

			cell.connect("flag_toggled", _on_cell_flag_toggled)

			if cell is EmptyCell:
				_setup_empty_cell(cell, row, column)

			_grid_container.add_child(cell)

func _clear_grid() -> void:
	_grid = []

	var children = _grid_container.get_children()

	for c in children:
		_grid_container.remove_child(c)
		c.queue_free()
	
func _generate_initial_grid() -> void:
	for row in _settings.rows:
		for column in _settings.columns:
			var cell: EmptyCell = empty_cell_scene.instantiate()
			cell.connect("pressed", _on_empty_cell_pressed.bind(row, column, 0))
			_grid_container.add_child(cell)

func _randomize_grid() -> void:
	var flat_grid = _generate_random_flat_grid()

	var flat_grid_index = 0

	for row in _settings.rows:
		_grid.append([])

		for column in _settings.columns:
			_grid[row].append(flat_grid[flat_grid_index])
			
			flat_grid_index += 1
	
func _generate_random_flat_grid() -> Array[Cell]:
	var flat_grid: Array[Cell] = []
	var _mines_to_place = _settings.mines

	for row in _settings.rows:
		for column in _settings.columns:
			if (_mines_to_place > 0):
				var mine_cell = _setup_mine_cell()

				flat_grid.append(mine_cell)

				_mines_to_place -= 1
			else:
				var empty_cell = empty_cell_scene.instantiate()

				flat_grid.append(empty_cell)

	flat_grid.shuffle()

	return flat_grid

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

			if (i != 0 or j != 0):
				var surrounding_cell: Cell = _grid[row + i][column + j]

				empty_cell.surrounding_cells.append(surrounding_cell)

				if surrounding_cell is MineCell:
					value += 1
	
	empty_cell.value = value

	empty_cell.connect("pressed", _on_empty_cell_pressed.bind(row, column, value))

func _propagate_press(x: int, y: int) -> void:
	for i in _DIRECTIONS:
		for j in _DIRECTIONS:
			if _is_outside_grid(x + i, y + j):
				continue
			
			var cell: Cell = _grid[x + i][y + j]

			## Calling cell.press() would add three function calls to the stack 
			## for each cell, causing a stack overflow. We avoid it by just revealing
			## the cell (which doesn't emit any signal), and continuing the propagation here
			if cell is EmptyCell and !cell.is_revealed:
				cell.reveal()

				empty_cell_pressed.emit(cell.flagged)

				if cell.value == 0:
					_propagate_press(x + i, y + j)

func _is_outside_grid(x: int, y: int) -> bool:
	return x < 0 or x >= _grid.size() or y < 0 or y >= _grid[0].size()

func _on_cell_flag_toggled(flagged: bool) -> void:
	flag_toggled.emit(flagged)
	
func _on_mine_cell_pressed() -> void:
	mine_pressed.emit()

func _on_empty_cell_pressed(flagged, x: int, y: int, value: int) -> void:
	if !_started:
		_setup(x, y)
		_started = true
		_grid[x][y].press()
		return

	empty_cell_pressed.emit(flagged)

	if value != 0:
		return

	_propagate_press(x, y)
