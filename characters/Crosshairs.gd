extends Control


func set_crosshair(ind):
	for child in get_children():
		child.hide()
	get_child(ind).show()
