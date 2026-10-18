extends Node

@export var _game: Game

func _on_menu_game_start_actioned(rows: int, columns: int, mines: int) -> void:
	%Menu.visible = false

	_game.initialize(rows, columns, mines)
	_game.visible = true
