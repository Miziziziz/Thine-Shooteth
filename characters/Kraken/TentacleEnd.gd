extends Spatial

var change_rate = 0.4
onready var sprites = get_children()
func _ready():
	display_random_child()
	var timer = Timer.new()
	timer.connect("timeout", self, "display_random_child")
	add_child(timer)
	timer.wait_time = change_rate
	timer.start()

func hide_all_children():
	for sprite in sprites:
		sprite.hide()

func display_random_child():
	hide_all_children()
	sprites[randi() % sprites.size()].show()
