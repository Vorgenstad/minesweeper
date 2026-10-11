class_name Game
extends CanvasLayer

@export var board_scene: PackedScene

@export var rows: int = 10
@export var columns: int = 10
@export var mines: int = 10

var _board: Board
var _empty_cells = rows * columns - mines
var _started := false

var _mine_count = mines

func _ready() -> void:
	_board = board_scene.instantiate()
	_board.connect("mine_pressed", _on_board_mine_pressed)
	_board.connect("empty_cell_pressed", _on_board_empty_cell_pressed)
	_board.connect("flag_toggled", _on_board_flag_toggled)

	_board.initialize(rows, columns, mines)

	%BoardContainer.add_child(_board)

	%TopBar.set_mines_left(mines)

func _start() -> void:
	if not _started:
		_started = true
		%TopBar.start_timer()

func _on_board_mine_pressed() -> void:
	get_tree().paused = true
	_board.display_loss()

func _on_board_empty_cell_pressed(flagged: bool) -> void:
	_start()

	_empty_cells -= 1

	if flagged:
		_mine_count += 1
		%TopBar.set_mines_left(_mine_count)

	if _empty_cells == 0:
		get_tree().paused = true
		_board.display_win()

func _on_top_bar_restart_actioned() -> void:
	get_tree().paused = false
	_board.reset()
	_started = false
	%TopBar.set_mines_left(mines)
	_mine_count = mines
	_empty_cells = rows * columns - mines

func _on_board_flag_toggled(flagged: bool) -> void:
	_start()

	if flagged:
		_mine_count -= 1
	else:
		_mine_count += 1

	%TopBar.set_mines_left(_mine_count)
