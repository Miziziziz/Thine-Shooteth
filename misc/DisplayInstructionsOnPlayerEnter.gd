extends Area


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$CanvasLayer/Label.hide()
	connect("body_entered", self, "body_entered")
	connect("body_exited", self, "body_exited")

func body_entered(body):
	if body.name == "Player":
		$CanvasLayer/Label.show()

func body_exited(body):
	if body.name == "Player":
		$CanvasLayer/Label.hide()
