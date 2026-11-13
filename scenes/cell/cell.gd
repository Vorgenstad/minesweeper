@abstract class_name Cell
extends PanelContainer

signal flag_toggled(flagged: bool)

@onready var _button: Button = %Button

var flagged := false:
	set(value):
		flagged = value

		if flagged:
			_button.text = "🚩"
			_button.disabled = true
		else:
			_button.text = ""
			_button.disabled = false

var is_revealed := false

@abstract func press() -> void

func toggle_flag() -> void:
	flagged = !flagged
	flag_toggled.emit(flagged)

func _on_button_pressed_right() -> void:
	toggle_flag()

func _on_button_pressed_left() -> void:
	press()
