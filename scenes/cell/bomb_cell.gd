class_name BombCell
extends PanelContainer

signal pressed

func _on_button_pressed() -> void:
	%Button.visible = false

	pressed.emit()
