class_name BombCell
extends Cell

signal pressed

func _on_button_pressed_left() -> void:
	%Button.visible = false

	pressed.emit()
