class_name CellButton
extends Button

signal pressed_left

signal pressed_right

func _gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				if disabled:
					return
				
				pressed_left.emit()
			MOUSE_BUTTON_RIGHT:
				pressed_right.emit()
