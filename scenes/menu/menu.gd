extends CanvasLayer

@export var max_size: int

@onready var _width_input: LineEdit = %WidthInput
@onready var _height_input: LineEdit = %HeightInput
@onready var _mines_input: LineEdit = %MinesInput
@onready var _error_label: Label = %ErrorLabel

@onready var _difficulty_container: Container = %DifficultyContainer
@onready var _custom_game_container: Container = %CustomGameContainer

signal game_start_actioned(settings: GameSettings)

func _print_error(message: String) -> void:
	_error_label.text = message

func _on_beginner_button_pressed() -> void:
	game_start_actioned.emit(GameSettings.new(9, 9, 10))

func _on_intermediate_button_pressed() -> void:
	game_start_actioned.emit(GameSettings.new(16, 16, 40))

func _on_expert_button_pressed() -> void:
	game_start_actioned.emit(GameSettings.new(16, 30, 99))

func _on_custom_button_pressed() -> void:
	_difficulty_container.visible = false
	_custom_game_container.visible = true

func _on_back_button_pressed() -> void:
	_difficulty_container.visible = true
	_custom_game_container.visible = false

func _on_play_custom_button_pressed() -> void:
	var width_text := _width_input.text
	var height_text := _height_input.text
	var mines_text := _mines_input.text

	if !width_text.is_valid_int():
		_print_error("Please enter a valid number for the width")
		return
	
	var width = int(width_text)

	if width < 1:
		_print_error("Width must be no less than 1")
		return
	
	if width > max_size:
		_print_error("Width must be no more than " + str(max_size))
		return
	
	if !height_text.is_valid_int():
		_print_error("Please enter a valid number for the height")
		return

	var height = int(height_text)

	if height < 1:
		_print_error("Height must be no less than 1")
		return
	
	if height > max_size:
		_print_error("Height must be no more than " + str(max_size))
		return

	if !mines_text.is_valid_int():
		_print_error("Please enter a valid number for the mines")
		return

	var mines = int(mines_text)

	if mines < 1:
		_print_error("Mines must be no less than 1")
		return

	if mines >= width * height:
		_print_error("There must be at least 1 empty cell")
		return

	game_start_actioned.emit(GameSettings.new(width, height, mines))
