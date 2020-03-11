extends KinematicBody

export var move_speed = 2
export var damage = 1

# sprite frame indexes
const FORWARD = 0
const FORWARD_RIGHT = 1
const BACKWARD = 2
const RIGHT = 3
const BACK_RIGHT = 4
const BACK_LEFT = 5
const LEFT = 6
const FORWARD_LEFT = 7
const BLANK = 8

var CREATE_SMOKE_AFTER_TIME = 4
var DELETE_AFTER_TIME = CREATE_SMOKE_AFTER_TIME + 4
var cur_lifespan = 0
var dead = false

var appear_after_time = 0.01

onready var smoke_particles = $SmokeParticles


var angles_to_frames = [
	{"frame": FORWARD, "angle_min": 337.5, "angle_max": 22.5},
	{"frame": FORWARD_LEFT, "angle_min": 22.5, "angle_max": 67.5},
	{"frame": LEFT, "angle_min": 67.5, "angle_max": 112.5},
	{"frame": BACK_LEFT, "angle_min": 112.5, "angle_max": 157.5},
	{"frame": BACKWARD, "angle_min": 157.5, "angle_max": 202.5},
	{"frame": BACK_RIGHT, "angle_min": 202.5, "angle_max": 247.5},
	{"frame": RIGHT, "angle_min": 247.5, "angle_max": 292.5},
	{"frame": FORWARD_RIGHT, "angle_min": 292.5, "angle_max": 337.5},
]
onready var sprite3d = $Sprite3D

var main_cam = null
func _ready():
	hide()
	main_cam = get_tree().get_nodes_in_group("main_camera")[0]

func _process(delta):
	cur_lifespan += delta
	if cur_lifespan > DELETE_AFTER_TIME:
		queue_free()
	if cur_lifespan > CREATE_SMOKE_AFTER_TIME:
		if !dead:
			smoke_particles.emitting = true
			dead = true
			$Sprite3D.hide()
	if cur_lifespan > appear_after_time:
		show()
	
	var y_angle = global_transform.basis.get_euler().y
	var pos = global_transform.origin
	pos.y = 0
	var c_pos = main_cam.global_transform.origin
	c_pos.y = 0
	var dir = pos.direction_to(c_pos).rotated(Vector3.UP, deg2rad(90) - y_angle) # angle is based on x, we want z
	var angle = rad2deg(atan2(dir.z, dir.x))
	if angle < 0:
		angle += 360
	
	sprite3d.frame = FORWARD
	for angle_info in angles_to_frames:
		if angle > angle_info.angle_min and angle <= angle_info.angle_max:
			sprite3d.frame = angle_info.frame
			break

var hit_something = false
func _physics_process(delta):
	if hit_something:
		return
	var collision = move_and_collide(move_speed * -global_transform.basis.z)
	if collision:
		hit_something = true
		$CollisionShape.disabled = true
		if collision.collider.has_method("hurt"):
			collision.collider.hurt(damage, -global_transform.basis.z)
			smoke_particles.emitting = true
			dead = true
			$Sprite3D.hide()
