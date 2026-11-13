class_name MineCell
extends Cell

signal pressed

func press() -> void:
	if is_revealed or flagged:
		return

	is_revealed = true

	_button.visible = false

	pressed.emit()

func reveal() -> void:
	assert(!flagged and !is_revealed, "Cannot reveal a flagged or pressed mine.")
	_button.text = "X"
