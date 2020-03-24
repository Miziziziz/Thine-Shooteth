extends Sprite3D


var change_rate = 0.4
func _ready():
	flip_h = randi() % 2 == 0
	var timer = Timer.new()
	timer.connect("timeout", self, "toggle_flip")
	add_child(timer)
	timer.wait_time = change_rate
	timer.start()


func toggle_flip():
	flip_h = !flip_h
