extends Area


func _ready():
	connect("body_entered", self, "body_entered")

signal player_entered
func body_entered(body):
	if body.name == "Player":
		emit_signal("player_entered")
