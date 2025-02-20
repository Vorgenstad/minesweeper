class_name Game
extends CanvasLayer

@export var board_scene: PackedScene

@export var rows: int = 10
@export var columns: int = 10
@export var bombs: int = 20

var empty_cells = rows * columns - bombs

func _ready() -> void:
	var board = board_scene.instantiate()

	board.connect("bomb_pressed", _on_board_bomb_pressed)
	board.connect("empty_cell_pressed", _on_board_empty_cell_pressed)

	board.generate(rows, columns, bombs)

	add_child(board)

func _on_board_bomb_pressed() -> void:
	print("Game over!")

func _on_board_empty_cell_pressed() -> void:
	empty_cells -= 1

	if empty_cells == 0:
		print("You win!")
