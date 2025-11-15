extends CanvasLayer

signal restart_actioned

func _on_restart_button_pressed() -> void:
	restart_actioned.emit()
