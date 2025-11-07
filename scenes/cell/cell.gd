class_name Cell
extends PanelContainer

var flagged := false

func _on_button_pressed_right() -> void:
	flagged = !flagged

	_update_state()

func _update_state() -> void:
	if flagged:
		%Button.text = "🚩"
		%Button.disabled = true
	else:
		%Button.text = ""
		%Button.disabled = false
