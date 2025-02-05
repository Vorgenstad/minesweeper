class_name Cell
extends PanelContainer

func _on_button_pressed_right() -> void:
	if %Button.disabled:
		%Button.text = ""
		%Button.disabled = false
	else:
		%Button.text = "🚩"
		%Button.disabled = true
