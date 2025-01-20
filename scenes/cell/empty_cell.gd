class_name EmptyCell
extends PanelContainer

@export var value := 0

func _ready() -> void:
	%Label.text = str(value) if value != 0 else ""

func _on_button_pressed() -> void:
	%Button.visible = false
