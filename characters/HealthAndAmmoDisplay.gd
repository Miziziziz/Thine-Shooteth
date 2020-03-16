extends Panel

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
	$AmmoDisplay.text = "Ammo: " + str(ammo)


func _on_Player_update_health(amount):
	update_health(amount)
