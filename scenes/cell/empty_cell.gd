class_name EmptyCell
extends Cell

signal pressed(flagged: bool)

@export var value := 0

var surrounding_cells: Array[Cell] = []

func _ready() -> void:
	var inner_button: Button = %InnerButton

	if value > 0:
		var color := inner_button.get_theme_color("value_" + str(value))

		inner_button.add_theme_color_override("font_color", color)
		inner_button.add_theme_color_override("font_hover_color", color)
		inner_button.add_theme_color_override("font_pressed_color", color)

		inner_button.text = str(value)

func press() -> void:
	if is_revealed:
		return

	reveal()

	pressed.emit(flagged)

func reveal() -> void:
	is_revealed = true

	_button.visible = false

func reveal_incorrect_flag() -> void:
	assert(flagged, "Cannot reveal incorrect flag on unflagged cell.")

	if flagged and !is_revealed:
		_button.text = "❌"

func _on_inner_button_pressed_left() -> void:
	var flagged_surrounding_cells: int = surrounding_cells.reduce(
		func(accum: int, cell: Cell) -> int:
			return accum + (1 if cell.flagged and !cell.is_revealed else 0), 0
	)

	if flagged_surrounding_cells == value:
		var unflagged_surrounding_cells := surrounding_cells.filter(func(cell: Cell) -> bool: return !cell.flagged)

		for cell: Cell in unflagged_surrounding_cells:
			cell.press()
