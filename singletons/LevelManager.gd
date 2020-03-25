extends Node


var level_list = [
	"res://levels/StartingLevel.tscn",
	"res://levels/MidLevel.tscn",
	"res://levels/FinalLevel.tscn",
	"res://levels/BossFight.tscn",
	"res://levels/ThanksForPlaying.tscn"
]

var cur_level_ind = 0
var player_data = {}
func restart_level():
	get_tree().call_group("instanced", "queue_free")
	yield(get_tree(),"idle_frame")
	yield(get_tree(),"idle_frame")
	get_tree().reload_current_scene()
	yield(get_tree(),"idle_frame")
	var player = get_player()
	$PortalSound.play()
	if player and player_data.size() != 0:
		get_player()._load(player_data)

func load_next_level():
	cur_level_ind += 1
	var player = get_player()
	player_data = {}
	if player:
		player_data = get_player()._save()
	get_tree().call_group("instanced", "queue_free")
	yield(get_tree(),"idle_frame")
	yield(get_tree(),"idle_frame")
	get_tree().change_scene(level_list[cur_level_ind % level_list.size()])
	yield(get_tree(),"idle_frame")
	player = get_player()
	$PortalSound.play()
	
	if player and player_data.size() != 0:
		get_player()._load(player_data)

func get_player():
	var players = get_tree().get_nodes_in_group("player")
	if len(players) > 0:
		return players[0]
	return null
