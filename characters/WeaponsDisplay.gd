extends Control

func _ready():
	$Crossbow.hide()
	$Fireball.hide()
	$Wands.hide()

func update_weapon(slot):
	$Selector.rect_position = get_child(slot).rect_position
	get_child(slot).show()


func _on_WeaponsManager_update_weapon(slot):
	update_weapon(slot + 1)
