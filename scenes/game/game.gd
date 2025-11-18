class_name Game
extends CanvasLayer

@export var board_scene: PackedScene

@export var rows: int = 10
@export var columns: int = 10
@export var mines: int = 10

var _board: Board
var _empty_cells = rows * columns - mines
var _started := false

func _ready() -> void:
	_board = board_scene.instantiate()
	_board.connect("bomb_pressed", _on_board_bomb_pressed)
	_board.connect("empty_cell_pressed", _on_board_empty_cell_pressed)
	_board.connect("flag_toggled", _on_board_flag_toggled)

	_board.initialize(rows, columns, mines)

	%Container.add_child(_board)

	%TopBar.set_mines_left(mines)

func _start() -> void:
	if not _started:
		_started = true
		%TopBar.start_timer()

func _on_board_bomb_pressed() -> void:
	get_tree().paused = true

	print("Game Over!")

func _on_board_empty_cell_pressed(flagged: bool) -> void:
	_start()

	_empty_cells -= 1

	if flagged:
		mines += 1
		%TopBar.set_mines_left(mines)

	if _empty_cells == 0:
		get_tree().paused = true
		print("You win!")

func _on_top_bar_restart_actioned() -> void:
	_board.reset()

func _on_board_flag_toggled(flagged: bool) -> void:
	_start()

	if flagged:
		mines -= 1
	else:
		mines += 1

	%TopBar.set_mines_left(mines)
