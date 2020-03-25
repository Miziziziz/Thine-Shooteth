extends AudioStreamPlayer

var music_paths = {
	"level1": "res://music/XTaKeRuX_-_01_-_Free_will_possession.ogg",
	"level2": "res://music/XTAKER_-_01_-_Shinigami.ogg",
	"level3":  "res://music/XTAKERU_-_02_-_Beast_but_not_least.ogg",
	"bossfight": "res://music/XTaKeRuX_-_03_-_White_Crow.ogg",
	"wind": "res://music/Hallow_Wind.ogg",
	"outro": "res://music/Iliaque_-_01_-_Once_a_freak_always_a_freak_vs_Klvntjes_I.ogg"
}

func _ready():
	pass

func play_level1_track():
	play_track("level1")

func play_level2_track():
	play_track("level2")

func play_level3_track():
	play_track("level3")

func play_bossfight_track():
	play_track("bossfight")

func play_wind():
	play_track("wind")

func play_outro_track():
	play_track("outro")

func play_track(track_ind):
	stream = load(music_paths[track_ind])
	play()
