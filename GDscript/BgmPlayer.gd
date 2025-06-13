extends Node  

@onready var bgm=$Bgmplayer

func play_music():
	if not bgm.playing:
		bgm.play()

func stop_music():
	bgm.stop()

func mute():
	bgm.volume_db = -80

func unmute():
	bgm.volume_db = 0
