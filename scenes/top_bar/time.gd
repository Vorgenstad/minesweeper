extends Label

var time := 0:
	set(value):
		time = value
		text = str(time).pad_zeros(3)

func clear() -> void:
	time = 0
	%Timer.stop()
	
func start() -> void:
	%Timer.start()

func _on_timer_timeout() -> void:
	time += 1
