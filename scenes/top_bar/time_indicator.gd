class_name TimeIndicator
extends Label

@onready var _timer: Timer = %Timer

var time := 0:
	set(value):
		time = value
		text = str(time).pad_zeros(3)

func clear() -> void:
	time = 0
	_timer.stop()
	
func start() -> void:
	_timer.start()

func _on_timer_timeout() -> void:
	time += 1
