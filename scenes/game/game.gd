class_name Game
extends CanvasLayer

@export var board_scene: PackedScene

var _settings: GameSettings

var _mine_count: int:
	set(value):
		_mine_count = value
		%TopBar.set_mines_left(_mine_count)

var _empty_cells_count: int

var _board: Board
var _started := false

func initialize(settings: GameSettings) -> void:
	_settings = settings

	_set_initial_counters()
	_initialize_board()

func _set_initial_counters() -> void:
	_empty_cells_count = _settings.rows * _settings.columns - _settings.mines
	_mine_count = _settings.mines

func _initialize_board() -> void:
	_board = board_scene.instantiate()
	_board.connect("mine_pressed", _on_board_mine_pressed)
	_board.connect("empty_cell_pressed", _on_board_empty_cell_pressed)
	_board.connect("flag_toggled", _on_board_flag_toggled)

	_board.initialize(_settings)

	%BoardContainer.add_child(_board)

func _start_if_not_started() -> void:
	if not _started:
		_started = true
		%TopBar.start_timer()

func _on_board_mine_pressed() -> void:
	get_tree().paused = true
	_board.display_loss()

func _on_board_empty_cell_pressed(flagged: bool) -> void:
	_start_if_not_started()

	_empty_cells_count -= 1

	if flagged:
		_mine_count += 1

	if _empty_cells_count == 0:
		get_tree().paused = true
		_board.display_win()

func _on_top_bar_restart_actioned() -> void:
	get_tree().paused = false

	_board.reset()
	_set_initial_counters()

	_started = false

func _on_board_flag_toggled(flagged: bool) -> void:
	_start_if_not_started()

	if flagged:
		_mine_count -= 1
	else:
		_mine_count += 1
