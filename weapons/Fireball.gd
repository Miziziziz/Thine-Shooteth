extends KinematicBody

var explosion = preload("res://weapons/Explosion.tscn")

export var start_move_speed = .5
export var grav = .2
export var drag = 0.01
export var velo_retained_on_bounce = 0.8
var velocity = Vector3.ZERO

func init():
	velocity = -global_transform.basis.z * start_move_speed

func _physics_process(delta):
	velocity += -velocity * drag + Vector3.DOWN * grav * delta
	var collision = move_and_collide(velocity)
	#r=d−2(d⋅n)n
	if collision:
		var d = velocity
		var n = collision.normal
		var r = d - 2 * d.dot(n) * n
		velocity = r * velo_retained_on_bounce
		if collision.collider.has_method("hurt"):
			detonate()

func detonate():
	var explosion_inst = explosion.instance()
	get_tree().get_root().add_child(explosion_inst)
	explosion_inst.global_transform.origin = global_transform.origin
	queue_free()
