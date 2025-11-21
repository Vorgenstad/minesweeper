@abstract class_name Cell
extends PanelContainer

signal flag_toggled(flagged: bool)

var flagged := false
var is_pressed := false

@abstract func press()

func toggle_flag() -> void:
	flagged = !flagged
	_update_display()
	flag_toggled.emit(flagged)

func _on_button_pressed_right() -> void:
	toggle_flag()

func _update_display() -> void:
	if flagged:
		%Button.text = "🚩"
		%Button.disabled = true
	else:
		%Button.text = ""
		%Button.disabled = false
