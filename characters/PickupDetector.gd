extends Area


signal picked_up

func _ready():
	connect("body_entered", self, "body_entered")

func body_entered(coll):
	if "pickup_type" in coll:
		match coll.pickup_type:
			coll.PICKUP_TYPES.HEALTH:
				emit_signal("picked_up", "health", coll.amount)
			coll.PICKUP_TYPES.CROSSBOW:
				emit_signal("picked_up", "crossbow", coll.amount)
			coll.PICKUP_TYPES.WAND: 
				emit_signal("picked_up", "wand", coll.amount)
			coll.PICKUP_TYPES.FIREBALL:
				emit_signal("picked_up", "fireball", coll.amount)
			coll.PICKUP_TYPES.CROSSBOW_AMMO: 
				emit_signal("picked_up", "crossbow_ammo", coll.amount)
			coll.PICKUP_TYPES.WAND_AMMO:
				emit_signal("picked_up", "wand_ammo", coll.amount)
			coll.PICKUP_TYPES.FIREBALL_AMMO:
				emit_signal("picked_up", "fireball_ammo", coll.amount)
		coll.queue_free()
