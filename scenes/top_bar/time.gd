extends Label

var time := 0

func _ready() -> void:
	text = str(time).pad_zeros(3)
	
func start() -> void:
	%Timer.start()

func _on_timer_timeout() -> void:
	time += 1
	text = str(time).pad_zeros(3)
