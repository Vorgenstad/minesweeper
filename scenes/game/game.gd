class_name Game
extends CanvasLayer

@export var board_scene: PackedScene

@export var rows: int = 10
@export var columns: int = 10
@export var bombs: int = 20


var _board: Board
var _empty_cells = rows * columns - bombs
var _started := false

func _ready() -> void:
	_board = board_scene.instantiate()
	_board.connect("bomb_pressed", _on_board_bomb_pressed)
	_board.connect("empty_cell_pressed", _on_board_empty_cell_pressed)

	_board.initialize(rows, columns, bombs)

	%Container.add_child(_board)

func _on_board_bomb_pressed() -> void:
	get_tree().paused = true

	print("Game Over!")

func _on_board_empty_cell_pressed() -> void:
	if not _started:
		_started = true
		%TopBar.start_timer()

	_empty_cells -= 1

	if _empty_cells == 0:
		get_tree().paused = true
		print("You win!")

func _on_top_bar_restart_actioned() -> void:
	_board.reset()
