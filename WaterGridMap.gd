extends GridMap


onready var num_of_tile_types = mesh_library.get_item_list().size()
func _ready():
	randomize_water_tiles()
	var timer = Timer.new()
	timer.connect("timeout", self, "toggle_water_tiles")
	add_child(timer)
	timer.wait_time = 0.8
	timer.start()

func randomize_water_tiles():
	for cell_coords in get_used_cells():
		var x = int(round(cell_coords.x))
		var y = int(round(cell_coords.y))
		var z = int(round(cell_coords.z))
		set_cell_item(x, y, z, randi() % num_of_tile_types)

func toggle_water_tiles():
	for cell_coords in get_used_cells():
		var x = int(round(cell_coords.x))
		var y = int(round(cell_coords.y))
		var z = int(round(cell_coords.z))
		var cell_type = get_cell_item(x, y, z)
		set_cell_item(x, y, z, (cell_type+1) % num_of_tile_types)


