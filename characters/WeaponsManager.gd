extends Spatial

onready var anim = $AnimationPlayer
onready var weapon_slots = $Weapons.get_children()
var cur_weapon = 0
var cur_slot = 0

func _ready():
	swap_to_weapon_slot(0)

func attack(attack_input_just_pressed, attack_input_held):
	if cur_weapon.has_method("fire"):
		cur_weapon.fire(attack_input_just_pressed, attack_input_held, self)

func swap_to_left_slot():
	cur_slot -= 1
	swap_to_weapon_slot(cur_slot)

func swap_to_right_slot():
	cur_slot += 1
	swap_to_weapon_slot(cur_slot)

func swap_to_weapon_slot(ind):
	ind %= weapon_slots.size()
	for weapon_slot in weapon_slots:
		weapon_slot.hide()
	#weapon_slots[ind].set_active()
	cur_weapon = weapon_slots[ind]
	cur_weapon.show()
	cur_slot = ind
	if cur_weapon.has_method("set_active"):
		cur_weapon.set_active()

func set_moving(is_moving):
	if is_moving and anim.current_animation != "walk":
		anim.play("walk")
	elif !is_moving and anim.current_animation != "idle":
		anim.play("idle")
