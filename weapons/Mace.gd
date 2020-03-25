extends Control

var damage = 20
export var attack_range = 4

onready var anim = $AnimationPlayer
var attack_point = null
var melee_area : Area = null

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
	
	var hit_something = false
	var hit_wall = false
	for body in melee_area.get_overlapping_bodies():
		if body.has_method("hurt"):
			body.hurt(damage, -attack_point.global_transform.basis.z)
			hit_something = true
		else:
			hit_wall = true
	
	if hit_something:
		$AttackHitSound.play()
	elif hit_wall:
		$AttackHitWallSound.play()
	else:
		$AttackMissSound.play()
		 
	
