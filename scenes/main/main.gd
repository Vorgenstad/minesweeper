extends Node

func _on_menu_game_start_actioned(rows: int, columns: int, mines: int) -> void:
	%Menu.visible = false

	%Game.initialize(rows, columns, mines)
	%Game.visible = true
