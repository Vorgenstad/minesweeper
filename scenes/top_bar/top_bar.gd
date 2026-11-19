class_name TopBar
extends HBoxContainer

signal restart_actioned

@export var normal_texture: Texture2D
@export var win_texture: Texture2D
@export var loss_texture: Texture2D

@onready var _time_indicator: TimeIndicator = %TimeIndicator
@onready var _restart_button: TextureButton = %RestartButton

func start_timer() -> void:
	_time_indicator.start()

func set_mines_left(mines_left: int) -> void:
	(%MinesLeft as Label).text = (str(mines_left).pad_zeros(2))

func display_win() -> void:
	_restart_button.texture_normal = win_texture

func display_loss() -> void:
	_restart_button.texture_normal = loss_texture

func _on_restart_button_pressed() -> void:
	_time_indicator.clear()
	_restart_button.texture_normal = normal_texture
	restart_actioned.emit()
