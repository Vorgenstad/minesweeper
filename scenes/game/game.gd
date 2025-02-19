class_name Game
extends CanvasLayer

@export var board_scene: PackedScene

func _ready() -> void:
	var board = board_scene.instantiate()

	board.connect("bomb_pressed", _on_board_bomb_pressed)

	board.generate(10, 10, 20)

	add_child(board)

func _on_board_bomb_pressed() -> void:
	print("Game over!")
