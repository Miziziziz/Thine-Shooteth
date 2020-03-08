extends Control

var attack_rate = 0.5
var last_attack_time = 0.0

onready var anim = $AnimationPlayer

func _ready():
	anim.current_animation = "idle"
	set_active()

func set_active():
	show()

func fire(attack_input_just_pressed, attack_input_held, attack_point):
	if attack_input_just_pressed and anim.current_animation == "idle":
		anim.play("attack")


func get_time():
	return OS.get_ticks_msec() / 1000.0

func attack():
	print("at")
