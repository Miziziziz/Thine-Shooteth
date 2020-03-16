extends Panel


func update_weapon(slot):
	$Selector.rect_position = get_child(slot).rect_position
	get_child(slot).show()


func _on_WeaponsManager_update_weapon(slot):
	update_weapon(slot)
