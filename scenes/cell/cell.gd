@abstract class_name Cell
extends PanelContainer

signal flag_toggled(flagged: bool)

var flagged := false
var is_pressed := false

@abstract func press()

func _on_button_pressed_right() -> void:
	flagged = !flagged

	flag_toggled.emit(flagged)

	_update_state()

func _update_state() -> void:
	if flagged:
		%Button.text = "🚩"
		%Button.disabled = true
	else:
		%Button.text = ""
		%Button.disabled = false
