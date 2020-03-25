extends Label


var list_of_things_picked_up = []
const MAX_NUM_OF_THINGS_DISPLAYED_AT_ONCE = 5

func add_item_to_display(item_name: String, amnt):
	if list_of_things_picked_up.size() >= MAX_NUM_OF_THINGS_DISPLAYED_AT_ONCE:
		remove_item_from_display()
	$Timer.start()
	if item_name == "wand":
		item_name = "bundle of wands"
	list_of_things_picked_up.push_front(item_name.replace("_", " "))
	update_display()

func remove_item_from_display():
	list_of_things_picked_up.pop_back()
	update_display()

func update_display():
	text = ""
	for item in list_of_things_picked_up:
		text += "picked up " + str(item) + "\n"
