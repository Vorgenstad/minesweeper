class_name MineCell
extends Cell

signal pressed

func press() -> void:
	if is_revealed or flagged:
		return

	is_revealed = true

	%Button.visible = false

	pressed.emit()

func reveal() -> void:
	assert(!flagged and !is_revealed, "Cannot reveal a flagged or pressed mine.")
	%Button.text = "X"
