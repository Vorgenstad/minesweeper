class_name BombCell
extends Cell

signal pressed

func press() -> void:
	if is_pressed or flagged:
		return

	%Button.visible = false

	pressed.emit()

func _on_button_pressed_left() -> void:
	press()
