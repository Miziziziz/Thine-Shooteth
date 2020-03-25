extends KinematicBody

var magic_missile = preload("res://weapons/MagicMissile.tscn")

enum STATES {IDLE, ATTACKING, DEAD}
var cur_state = STATES.IDLE

export var health = 100
export var fire_rate = 1.0
var time_since_fired = 0.0
var move_speed = 3
var player = null
onready var nav = get_parent()


func _ready():
	player = get_tree().get_nodes_in_group("player")[0]

func set_state_idle():
	cur_state = STATES.IDLE

func set_state_attack():
	cur_state = STATES.ATTACKING
	time_since_fired = 0.0

func set_state_dead():
	cur_state = STATES.DEAD
	$AnimationPlayer.play("death")
	$AttackAnimationPlayer.stop()
	$CollisionShape.disabled = true
	$DeathSound.play()

func process_state_idle(delta):
	if has_line_of_sight_to_player():
		set_state_attack()

func process_state_attack(delta):
	time_since_fired += delta
	if has_line_of_sight_to_player() and time_since_fired >= fire_rate:
		time_since_fired = 0.0
		$AttackAnimationPlayer.play("attack")
	else:
		# chase player
		pass

func process_state_dead(delta):
	pass

func _process(delta):
	match cur_state:
		STATES.IDLE:
			process_state_idle(delta)
		STATES.ATTACKING:
			process_state_attack(delta)
		STATES.DEAD:
			process_state_dead(delta)

func fire():
	var magic_missile_inst = magic_missile.instance()
	get_tree().get_root().add_child(magic_missile_inst)
	var pos = global_transform.origin + Vector3.UP * 1.5
	var dir = pos.direction_to(get_player_pos())
	magic_missile_inst.global_transform.origin = pos + dir
	magic_missile_inst.global_transform.basis.z = -dir
	$AttackSound.play()

func _physics_process(delta):
	if cur_state != STATES.ATTACKING:
		return
	if  has_line_of_sight_to_player():
		return
	var pos = global_transform.origin
	var path = nav.get_simple_path(pos, player.global_transform.origin)
	if path.size() > 0:
		var dir = pos.direction_to(path[1])
		dir.y = 0
		move_and_collide(dir * move_speed * delta)
		global_transform.origin.y = 0

func get_player_pos():
	return player.global_transform.origin + Vector3.UP

func has_line_of_sight_to_player():
	var space_state = get_world().get_direct_space_state()
	var pos = global_transform.origin + Vector3.UP
	var result = space_state.intersect_ray(pos,  player.global_transform.origin, [self], 1)
	if result:
		return false
	return true

func hurt(damage: int, dir = Vector3.UP):
	if cur_state == STATES.DEAD:
		return
	health -= damage
	$AttackAnimationPlayer.play("hurt")
	$HurtSound.play()
	#time_since_fired = 0.0
	if health <= 0:
		set_state_dead()
