extends HBoxContainer

signal restart_actioned

func start_timer() -> void:
	%Time.start()

func set_mines_left(mines_left: int) -> void:
	%MinesLeft.text = (str(mines_left).pad_zeros(2))

func _on_restart_button_pressed() -> void:
	restart_actioned.emit()
