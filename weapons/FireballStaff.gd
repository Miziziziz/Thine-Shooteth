extends Control

var fireball_obj = preload("res://weapons/Fireball.tscn")
onready var anim = $AnimationPlayer

func _ready():
	anim.current_animation = "idle"
	set_active()

func set_active():
	show()

func fire(attack_input_just_pressed, attack_input_held, attack_point):
	if attack_input_just_pressed and anim.current_animation == "idle":
		anim.play("shoot")
		var fireball_inst = fireball_obj.instance()
		get_tree().get_root().add_child(fireball_inst)
		fireball_inst.global_transform = attack_point.global_transform
		fireball_inst.init()
		return 1
	return 0
