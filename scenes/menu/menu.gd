extends CanvasLayer

signal game_start_actioned(rows: int, columns: int, mines: int)

func _on_beginner_button_pressed() -> void:
	game_start_actioned.emit(9, 9, 10)

func _on_intermediate_button_pressed() -> void:
	game_start_actioned.emit(16, 16, 40)

func _on_expert_button_pressed() -> void:
	game_start_actioned.emit(16, 30, 99)
