extends Area

export var damage = 40

func _ready():
	# have to wait a couple frames for the area to see everything inside
	yield(get_tree(),"physics_frame")
	yield(get_tree(),"physics_frame")
	yield(get_tree(),"physics_frame")
	yield(get_tree(),"physics_frame")
	$Particles.emitting = true
	for body in get_overlapping_bodies():
		if body.has_method("hurt"):
			body.hurt(damage, global_transform.origin.direction_to(body.global_transform.origin))
