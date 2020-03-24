extends KinematicBody

enum STATES {IDLE, CHASING, ATTACKING, DEAD}
var cur_state = STATES.IDLE

export var damage = 5
export var health = 30
export var attack_range = 3.5
export var start_attack_range = 2.5
var move_speed = 12
var player = null
onready var nav = get_parent()

func _ready():
	player = get_tree().get_nodes_in_group("player")[0]

func set_state_idle():
	cur_state = STATES.IDLE
	$AnimationPlayer.play("idle")

func set_state_chase():
	cur_state = STATES.CHASING
	$AnimationPlayer.play("run")

func set_state_attack():
	cur_state = STATES.ATTACKING
	$AnimationPlayer.play("attack")

func set_state_dead():
	cur_state = STATES.DEAD
	$AnimationPlayer.play("death")
	$CollisionShape.disabled = true

func process_state_idle(delta):
	if has_line_of_sight_to_player():
		set_state_chase()

func process_state_chase(delta):
	if global_transform.origin.distance_squared_to(player.global_transform.origin) < start_attack_range*start_attack_range:
		set_state_attack()

func process_state_attack(delta):
	if !$AnimationPlayer.is_playing():
		set_state_chase()

func process_state_dead(delta):
	pass

func _process(delta):
	var dir = player.global_transform.origin - global_transform.origin
	rotation.y = atan2(dir.x, dir.z)
	
	match cur_state:
		STATES.IDLE:
			process_state_idle(delta)
		STATES.CHASING:
			process_state_chase(delta)
		STATES.ATTACKING:
			process_state_attack(delta)
		STATES.DEAD:
			process_state_dead(delta)

func _physics_process(delta):
	if cur_state != STATES.CHASING:
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

func finish_attack():
	if !has_line_of_sight_to_player():
		return
	if global_transform.origin.distance_squared_to(player.global_transform.origin) < attack_range*attack_range:
		player.hurt(damage, global_transform.origin.direction_to(player.global_transform.origin))
	#set_state_chase()

func hurt(damage: int, dir = Vector3.UP):
	if cur_state == STATES.DEAD:
		return
	health -= damage
	$HurtAnimationPlayer.play("hurt")
	if health <= 0:
		set_state_dead()
		$BloodParticles.emitting=true
