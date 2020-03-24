extends KinematicBody


func hurt(damage, dir):
	get_parent().hurt(damage, dir)
