extends HBoxContainer

signal restart_actioned

func start_timer() -> void:
	%Time.start()

func _on_restart_button_pressed() -> void:
	restart_actioned.emit()
