class_name MineCell
extends Cell

signal pressed

func press() -> void:
	if is_pressed or flagged:
		return

	%Button.visible = false

	pressed.emit()

func reveal() -> void:
	assert(!flagged and !is_pressed, "Cannot reveal a flagged or pressed mine.")
	%Button.text = "X"

func _on_button_pressed_left() -> void:
	press()
