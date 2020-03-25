extends Control


func _process(delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
