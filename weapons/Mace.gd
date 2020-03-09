extends Control

export var attack_range = 2

onready var anim = $AnimationPlayer
var attack_point = null

func _ready():
	anim.current_animation = "idle"
	set_active()

func set_active():
	show()

func fire(attack_input_just_pressed, attack_input_held, _attack_point):
	attack_point = _attack_point
	if attack_input_just_pressed and anim.current_animation == "idle":
		anim.play("attack")

func attack():
	var space_state = attack_point.get_world().get_direct_space_state()
	var pos = attack_point.global_transform.origin
	var result = space_state.intersect_ray(pos, pos + -attack_point.global_transform.basis.z * attack_range)
	if result:
		pass
	
