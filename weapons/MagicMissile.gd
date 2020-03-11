extends KinematicBody

export var move_speed = 2.0
export var damage = 5

var smoke = preload("res://weapons/SmokeParticles.tscn")

func _physics_process(delta):
	var collision = move_and_collide(move_speed * -global_transform.basis.z)
	if collision:
		if collision.collider.has_method("hurt"):
			collision.collider.hurt(damage, global_transform.origin.direction_to(collision.position))
		var smoke_inst = smoke.instance()
		get_tree().get_root().add_child(smoke_inst)
		smoke_inst.global_transform.origin = global_transform.origin
		smoke_inst.emitting = true
		queue_free()

func set_new_sprite(new_texture):
	$Sprite3D.texture = new_texture

func show_sprite():
	$Sprite3D.show()
