#extends Node
#
#@onready var player: AudioStreamPlayer = AudioStreamPlayer.new()
#
#func _ready():
	#add_child(player)
	#player.stream = load("res://assets/BGM/forest_wandering.mp3")
	#player.volume_db = -5    
	#player.play()
#
#func fade_volume(target_db: float, duration: float) -> void:
	#var tween = create_tween()
	#tween.tween_property(player, "volume_db", target_db, duration)
