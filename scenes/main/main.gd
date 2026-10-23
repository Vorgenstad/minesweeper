extends Node

func _on_menu_game_start_actioned(settings: GameSettings) -> void:
	%Menu.visible = false

	%Game.initialize(settings)
	%Game.visible = true
