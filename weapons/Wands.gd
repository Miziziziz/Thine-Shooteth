extends Control

var magic_missile = preload("res://weapons/MagicMissile.tscn")

onready var anim = $AnimationPlayer

onready var flashes = $Flashes.get_children()
export var fire_rate = 0.1
var last_attack_time = 0.0
var cur_time = 0.0


func _ready():
	set_active()

func set_active():
	show()

func fire(attack_input_just_pressed, attack_input_held, attack_point):
	if attack_input_held and get_time() > last_attack_time + fire_rate:
		for flash in flashes:
			flash.hide()
		var flash_ind = randi() % flashes.size()
		flashes[flash_ind].show()
		$AnimationPlayer.play("fire")
		last_attack_time = get_time()
		var magic_missile_inst = magic_missile.instance()
		get_tree().get_root().add_child(magic_missile_inst)
		magic_missile_inst.global_transform = attack_point.global_transform
		magic_missile_inst.set_new_sprite(flashes[flash_ind].texture)
		return 1
	return 0

func get_time():
	return OS.get_ticks_msec() / 1000.0
