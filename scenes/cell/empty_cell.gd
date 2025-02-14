class_name EmptyCell
extends Cell

signal pressed(x: int, y: int, value: int)

var is_pressed := false

@export var value := 0

func _ready() -> void:
	%Label.text = str(value) if value != 0 else ""

func press() -> void:
	is_pressed = true

	%Button.visible = false

	pressed.emit()

func _on_button_pressed_left() -> void:
	press()
