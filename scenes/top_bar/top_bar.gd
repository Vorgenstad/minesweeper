class_name TopBar
extends HBoxContainer

signal restart_actioned

@onready var _time_indicator: TimeIndicator = %TimeIndicator

func start_timer() -> void:
	_time_indicator.start()

func set_mines_left(mines_left: int) -> void:
	(%MinesLeft as Label).text = (str(mines_left).pad_zeros(2))

func _on_restart_button_pressed() -> void:
	_time_indicator.clear()
	restart_actioned.emit()
