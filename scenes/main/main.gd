extends Node

func _on_menu_game_start_actioned(settings: GameSettings) -> void:
	(%Menu as CanvasLayer).visible = false

	(%Game as Game).initialize(settings)
	(%Game as Game).visible = true
