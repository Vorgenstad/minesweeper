class_name EmptyCell
extends Cell

signal pressed(x: int, y: int, value: int)

@export var value := 0

var surrounding_cells := []

func _ready() -> void:
	%InnerButton.text = str(value) if value != 0 else ""

func press() -> void:
	if is_pressed:
		return

	is_pressed = true

	%Button.visible = false

	pressed.emit()

func _on_button_pressed_left() -> void:
	press()

func _on_inner_button_pressed_left() -> void:
	var flagged_surrounding_cells: int = surrounding_cells.reduce(func(accum, cell): return accum + (1 if cell.flagged else 0), 0)

	if flagged_surrounding_cells == value:
		var unflagged_surrounding_cells := surrounding_cells.filter(func(cell): return !cell.flagged)

		for cell in unflagged_surrounding_cells:
			cell.press()
