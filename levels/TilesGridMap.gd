extends GridMap

var min_wall_height = 5
var max_wall_height = 8
func _ready():
	#make walls taller
	for cell_coords in get_used_cells():
		var x = int(round(cell_coords.x))
		var y = int(round(cell_coords.y))
		var z = int(round(cell_coords.z))
		var cell_type = get_cell_item(x, y, z)
		if cell_type % 2 == 0:
			var wall_height = (randi() % (max_wall_height - min_wall_height)) + min_wall_height
			for i in range(wall_height):
				set_cell_item(x, y + i + 1, z, cell_type)

