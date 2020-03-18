extends Control

var health = 100
var ammo = 10

func update_ammo(amount):
	ammo = amount
	update_display()

func update_health(amount):
	health = amount
	update_display()

func update_display():
	$HealthDisplay.text = "Health: " + str(health)
	var s_ammo = str(ammo)
	if ammo < 0:
		s_ammo = "oo"
	$AmmoDisplay.text = "Ammo: " + s_ammo


func _on_Player_update_health(amount):
	update_health(amount)
