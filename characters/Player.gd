extends KinematicBody

export var move_accel = 4
export var drag = 0.4
export var jump_force = 20
export var gravity = 60
export var mouse_sens = 0.5

var velocity = Vector3()
var snap_vec = Vector3()

onready var camera = $Camera
onready var weapons_manager = $Camera/WeaponsManager

signal shoot
signal moving
signal still

var max_lean = 1.5
var cur_lean = 0.0
var lean_rate_out = 55.0
var lean_rate_in = 15.0

const MAX_HEALTH = 100
var cur_health = MAX_HEALTH

var hotkeys = {
	KEY_1: 0,
	KEY_2: 1,
	KEY_3: 2,
	KEY_4: 3,
	KEY_5: 4,
	KEY_6: 5,
	KEY_7: 6,
	KEY_8: 7,
	KEY_9: 8,
	KEY_0: 9,
}

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode in hotkeys:
			weapons_manager.swap_to_weapon_slot(hotkeys[event.scancode])
	
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_WHEEL_DOWN:
			weapons_manager.swap_to_right_slot()
		if event.button_index == BUTTON_WHEEL_UP:
			weapons_manager.swap_to_left_slot()

	if event is InputEventMouseMotion:
		rotation_degrees.y -= mouse_sens * event.relative.x
		camera.rotation_degrees.x -= mouse_sens * event.relative.y
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -90, 90)

func _process(delta):
	if Input.is_action_pressed("exit"):
		get_tree().quit()
	if Input.is_action_pressed("restart"):
		get_tree().call_group("instanced", "queue_free")
		get_tree().reload_current_scene()
		
	var attack_input_just_pressed = Input.is_action_just_pressed("shoot")
	var attack_input_held = Input.is_action_pressed("shoot")
	weapons_manager.attack(attack_input_just_pressed, attack_input_held)

func _physics_process(delta):
	var move_vec = Vector3()
	if Input.is_action_pressed("move_forwards"):
		move_vec += Vector3.FORWARD
	if Input.is_action_pressed("move_backwards"):
		move_vec += Vector3.BACK
	if Input.is_action_pressed("move_left"):
		move_vec += Vector3.LEFT
	if Input.is_action_pressed("move_right"):
		move_vec += Vector3.RIGHT
	
	if move_vec.x != 0:
		cur_lean += lean_rate_out * delta * -sign(move_vec.x)
		cur_lean = clamp(cur_lean, -max_lean, max_lean)
	elif cur_lean != 0:
		var lean_amnt = delta * lean_rate_in
		if abs(cur_lean) < lean_amnt:
			cur_lean = 0.0
		else:
			cur_lean += -sign(cur_lean) * lean_amnt
	$Camera.rotation_degrees.z = cur_lean
		
	
	move_vec = move_vec.normalized()
	move_vec = move_vec.rotated(Vector3.UP, rotation.y)	
	
	velocity += move_accel * move_vec - velocity * Vector3(drag,0,drag) + gravity * Vector3.DOWN * delta
	velocity = move_and_slide_with_snap(velocity + get_floor_velocity() , Vector3.UP, Vector3.UP, false, 4, PI, false)
	global_transform.origin.y = 0
	
	weapons_manager.set_moving(Vector3.ZERO != move_vec)

signal update_health
func pickup_item(type:String, amount:int):
	if type == "health":
		cur_health += amount
		if cur_health >= MAX_HEALTH:
			cur_health = MAX_HEALTH
	emit_signal("update_health", cur_health)

func hurt(damage: int, dir: Vector3):
	cur_health -= damage
	emit_signal("update_health", cur_health)
