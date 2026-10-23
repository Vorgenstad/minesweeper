class_name MineCell
extends Cell

signal pressed

func press() -> void:
	if is_pressed or flagged:
		return

	is_pressed = true

	%Button.visible = false

	pressed.emit()

func reveal() -> void:
	assert(!flagged and !is_pressed, "Cannot reveal a flagged or pressed mine.")
	%Button.text = "X"
