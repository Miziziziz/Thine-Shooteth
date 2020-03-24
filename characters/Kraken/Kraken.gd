extends Spatial

var magic_missile = preload("res://weapons/MagicMissile.tscn")
var fireball = preload("res://weapons/Fireball.tscn")
onready var magic_missile_attack_point = $Head/MagicMissileAttackPoint
onready var fireball_attack_point = $Head/FireballAttackPoint

export var health = 1000
var start_health = 0.0

enum STATES { IDLE, ATTACK, DEAD}
var cur_state = STATES.IDLE

enum ATTACK_TYPES { MAGIC_MISSILE, FIREBALL, REST}
var cur_attack_type = ATTACK_TYPES.MAGIC_MISSILE

var cur_attack_count = 0

var fireball_attack_count = 4
var magic_missile_attack_count = 12

var magic_attack_rate = 0.2
var fireball_attack_rate = 0.4
var rest_time = 1.0

var berserk_fireball_attack_count = 8
var berserk_magic_missile_attack_count = 25

var berserk_magic_attack_rate = 0.1
var berserk_fireball_attack_rate = 0.2
var berserk_rest_time = 1.0

var cur_time = 0.0

var player = null

signal dead

func _ready():
	player = get_tree().get_nodes_in_group("player")[0]
	start_health = float(health)
	emit_signal("update_health_percent", 100 * health / start_health)
	$AnimationPlayer.play("idle")

func _process(delta):
	cur_time += delta
	match cur_state:
		STATES.IDLE:
			process_state_idle(delta)
		STATES.ATTACK:
			process_state_attack(delta)
		STATES.DEAD:
			process_state_dead(delta)

func set_state_idle():
	cur_state = STATES.IDLE
	$AnimationPlayer.play("idle")

func set_state_attack():
	cur_state = STATES.ATTACK
	#choose_rand_attack_type()
	cur_attack_type = ATTACK_TYPES.MAGIC_MISSILE
	$StateAnimationPlayer.play("riseup")

func set_state_dead():
	cur_state = STATES.DEAD
	$AnimationPlayer.play("attack")
	$StateAnimationPlayer.play("descend")
	emit_signal("dead")

func process_state_idle(delta: float):
	pass

func process_state_attack(delta: float):
	var offset = player.global_transform.origin - global_transform.origin
	var scatter = sin(2.0 * OS.get_ticks_msec()/1000.0) * PI/8
	$Head.rotation.y = atan2(offset.x, offset.z) + PI + scatter
	#attack_point.global_transform.basis.z = global_transform.origin.direction_to(player.global_transform.origin)
	
	if cur_attack_type == ATTACK_TYPES.MAGIC_MISSILE:
		var attack_rate = magic_attack_rate
		var max_attack_count = magic_missile_attack_count
		if is_berserk():
			attack_rate = berserk_magic_attack_rate
			max_attack_count = berserk_magic_missile_attack_count
		if cur_time >= attack_rate:
			magic_missile_attack()
			cur_attack_count += 1
			if cur_attack_count >= max_attack_count:
				cur_attack_type = ATTACK_TYPES.REST
				$AnimationPlayer.play("idle")
				cur_attack_count = 0
			cur_time = 0.0
	elif cur_attack_type == ATTACK_TYPES.FIREBALL:
		var attack_rate = fireball_attack_rate
		var max_attack_count = fireball_attack_count
		if is_berserk():
			attack_rate = berserk_fireball_attack_rate
			max_attack_count = berserk_fireball_attack_count
		if cur_time >= attack_rate:
			fireball_attack()
			cur_attack_count += 1
			if cur_attack_count >= max_attack_count:
				cur_attack_type = ATTACK_TYPES.REST
				$AnimationPlayer.play("idle")
				cur_attack_count = 0
			cur_time = 0.0
	else:
		var cur_time_to_rest = rest_time
		if is_berserk():
			cur_time_to_rest = berserk_rest_time
		if cur_time >= cur_time_to_rest:
			cur_time = 0.0
			choose_rand_attack_type()

func process_state_dead(delta: float):
	pass

func choose_rand_attack_type():
	if randi() % 2 == 0:
		cur_attack_type = ATTACK_TYPES.MAGIC_MISSILE
	else:
		cur_attack_type = ATTACK_TYPES.FIREBALL

func magic_missile_attack():
	$AnimationPlayer.play("attack")
	var magic_missile_inst = magic_missile.instance()
	get_tree().get_root().add_child(magic_missile_inst)
	magic_missile_inst.global_transform = magic_missile_attack_point.global_transform

func fireball_attack():
	$AnimationPlayer.play("attack")
	var fireball_inst = fireball.instance()
	get_tree().get_root().add_child(fireball_inst)
	fireball_inst.global_transform = fireball_attack_point.global_transform
	fireball_inst.init()

signal update_health_percent

func hurt(damage: int, dir: Vector3):
	if cur_state == STATES.DEAD:
		return
	if cur_state == STATES.IDLE:
		set_state_attack()
	var was_berserk = is_berserk()
	health -= damage
	if !was_berserk and is_berserk():
		$StateAnimationPlayer.play("raiseextra")
	emit_signal("update_health_percent", 100 * health / start_health)
	$HurtAnimationPlayer.play("hurt")
	if health <= 0:
		set_state_dead()

func is_berserk():
	return health / start_health < 0.5
