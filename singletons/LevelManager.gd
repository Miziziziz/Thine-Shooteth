extends Node


var level_list = [
	"res://levels/StartingLevel.tscn",
	"res://levels/MidLevel.tscn",
	"res://levels/FinalLevel.tscn",
	"res://levels/BossFight.tscn"
]

var cur_level_ind = 0

func load_next_level():
	cur_level_ind += 1
	var player = get_player()
	var player_data = {}
	if player:
		player_data = get_player()._save()
	get_tree().call_group("instanced", "queue_free")
	get_tree().change_scene(level_list[cur_level_ind % level_list.size()])
	yield(get_tree(),"idle_frame")
	player = get_player()
	
	if player and player_data.size() != 0:
		get_player()._load(player_data)

func get_player():
	var players = get_tree().get_nodes_in_group("player")
	if len(players) > 0:
		return players[0]
	return null
