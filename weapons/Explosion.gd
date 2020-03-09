extends Area

export var damage = 5

func _ready():
	$Particles.emitting = true
	for body in get_overlapping_bodies():
		if body.has_method("hurt"):
			body.hurt(damage, global_transform.origin.direction_to(body.global_transform.origin))
