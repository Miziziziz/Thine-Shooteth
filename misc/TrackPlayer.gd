extends Node


enum TRACKS {LEVEL1, LEVEL2, LEVEL3, BOSSFIGHT, OUTRO, WIND}
export (TRACKS) var track_to_play
export var play_on_start = true

func _ready():
	if play_on_start:
		start_track()

func start_track():
	match track_to_play:
		TRACKS.LEVEL1:
			MusicManager.play_level1_track()
		TRACKS.LEVEL2:
			MusicManager.play_level2_track()
		TRACKS.LEVEL3:
			MusicManager.play_level3_track()
		TRACKS.BOSSFIGHT:
			MusicManager.play_bossfight_track()
		TRACKS.OUTRO:
			MusicManager.play_outro_track()
		TRACKS.WIND:
			MusicManager.play_wind()
