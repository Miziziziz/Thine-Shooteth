extends Spatial

onready var anim = $AnimationPlayer
onready var weapon_slots = $Weapons.get_children()
var cur_weapon = 0
var cur_slot = 0

var crossbow_ammo = 0
var wand_ammo = 0
var fireball_ammo = 0

var slots_unlocked = {WEAPON_SLOT_IDS.MACE_SLOT: ''}

enum WEAPON_SLOT_IDS {MACE_SLOT, CROSSBOW_SLOT, WAND_SLOT, FIREBALL_SLOT}

func _ready():
	$Weapons/Mace.melee_area = $MeleeShape
	swap_to_weapon_slot(WEAPON_SLOT_IDS.MACE_SLOT)

func attack(attack_input_just_pressed, attack_input_held):
	if !attack_input_held and !attack_input_just_pressed:
		return
	if cur_weapon.has_method("fire"):
		match cur_slot:
			WEAPON_SLOT_IDS.CROSSBOW_SLOT:
				if crossbow_ammo <= 0:
					if attack_input_just_pressed:
						$Weapons/Crossbow/OutOfAmmoSound.play()
					return
			WEAPON_SLOT_IDS.WAND_SLOT:
				if wand_ammo <= 0:
					if attack_input_just_pressed:
						$Weapons/Wands/OutOfAmmoSound.play()
					return
			WEAPON_SLOT_IDS.FIREBALL_SLOT:
				if fireball_ammo <= 0:
					if attack_input_just_pressed:
						$Weapons/FireballStaff/OutOfAmmoSound.play()
					return
		var ammo_used = cur_weapon.fire(attack_input_just_pressed, attack_input_held, self)
		if ammo_used and ammo_used <= 0:
			return
		match cur_slot:
			WEAPON_SLOT_IDS.CROSSBOW_SLOT:
				crossbow_ammo -= ammo_used
				emit_signal("update_ammo", crossbow_ammo)
			WEAPON_SLOT_IDS.WAND_SLOT:
				wand_ammo -= ammo_used
				emit_signal("update_ammo", wand_ammo)
			WEAPON_SLOT_IDS.FIREBALL_SLOT:
				fireball_ammo -= ammo_used
				emit_signal("update_ammo", fireball_ammo)

func swap_to_left_slot():
	cur_slot -= 1
	if !swap_to_weapon_slot(cur_slot):
		swap_to_left_slot()

func swap_to_right_slot():
	cur_slot += 1
	if !swap_to_weapon_slot(cur_slot):
		swap_to_right_slot()

func swap_to_weapon_slot(ind):
	ind %= weapon_slots.size()
	if ind < 0:
		ind += weapon_slots.size()
	if not ind in slots_unlocked:
		return false
	
	for weapon_slot in weapon_slots:
		weapon_slot.hide()
	cur_weapon = weapon_slots[ind]
	cur_weapon.show()
	cur_slot = ind
	if cur_weapon.has_method("set_active"):
		cur_weapon.set_active()
	
	match ind:
		WEAPON_SLOT_IDS.MACE_SLOT:
			emit_signal("update_ammo", -1)
		WEAPON_SLOT_IDS.CROSSBOW_SLOT:
			emit_signal("update_ammo", crossbow_ammo)
		WEAPON_SLOT_IDS.WAND_SLOT:
			emit_signal("update_ammo", wand_ammo)
		WEAPON_SLOT_IDS.FIREBALL_SLOT:
			emit_signal("update_ammo", fireball_ammo)
	emit_signal("update_weapon", cur_slot)
	return true

func set_moving(is_moving):
	if is_moving and anim.current_animation != "walk":
		anim.play("walk")
	elif !is_moving and anim.current_animation != "idle":
		anim.play("idle")

signal update_ammo
signal update_weapon
func pickup_item(type:String, amount:int):
	if type == "crossbow":
		$Weapons/Crossbow/PickupSound.play()
		slots_unlocked[WEAPON_SLOT_IDS.CROSSBOW_SLOT] = ''
		crossbow_ammo += amount
		swap_to_weapon_slot(WEAPON_SLOT_IDS.CROSSBOW_SLOT)
	elif type == "wand":
		$Weapons/Wands/PickupSound.play()
		slots_unlocked[WEAPON_SLOT_IDS.WAND_SLOT] = ''
		wand_ammo += amount
		swap_to_weapon_slot(WEAPON_SLOT_IDS.WAND_SLOT)
	elif type == "fireball":
		$Weapons/FireballStaff/PickupSound.play()
		slots_unlocked[WEAPON_SLOT_IDS.FIREBALL_SLOT] = ''
		fireball_ammo += amount
		swap_to_weapon_slot(WEAPON_SLOT_IDS.FIREBALL_SLOT)
	elif type == "crossbow_ammo":
		crossbow_ammo += amount
		if cur_slot == WEAPON_SLOT_IDS.CROSSBOW_SLOT:
			emit_signal("update_ammo", crossbow_ammo)
	elif type == "wand_ammo":
		wand_ammo += amount
		if cur_slot == WEAPON_SLOT_IDS.WAND_SLOT:
			emit_signal("update_ammo", wand_ammo)
	elif type == "fireball_ammo":
		fireball_ammo += amount
		if cur_slot == WEAPON_SLOT_IDS.FIREBALL_SLOT:
			emit_signal("update_ammo", fireball_ammo)

func update_display():
	var tmp = cur_slot
	for slot in slots_unlocked:
		swap_to_weapon_slot(slot)
	swap_to_weapon_slot(tmp)
