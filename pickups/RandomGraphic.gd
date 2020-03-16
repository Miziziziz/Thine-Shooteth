extends Spatial


func _ready():
	for child in get_children():
		child.hide()
	get_child(randi() % get_child_count()).show()
