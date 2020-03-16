extends Control

var angles = [-5, -2.5, 0, 2.5, 5]
var arrow_obj = preload("res://weapons/Arrow.tscn")

onready var anim = $AnimationPlayer

func _ready():
	anim.current_animation = "idle"
	set_active()

func set_active():
	show()
	if anim.current_animation != "idle":
		anim.play("shoot")
		anim.seek(0.15, true)

func fire(attack_input_just_pressed, attack_input_held, attack_point):
	if attack_input_just_pressed and anim.current_animation == "idle":
		anim.play("shoot")
		for angle in angles:
			var arrow_inst = arrow_obj.instance()
			get_tree().get_root().add_child(arrow_inst)
			arrow_inst.global_transform = attack_point.global_transform
			arrow_inst.rotate_object_local(Vector3.UP, deg2rad(angle))
		return 1
	return 0
