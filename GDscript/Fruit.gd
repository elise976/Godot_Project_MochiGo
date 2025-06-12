extends Node2D

@export var fruit_type: String = "apple"

func _ready():
	var sprite = $AnimatedSprite2D
	var path = "res://fruits/%s_frames.tres" % fruit_type
	if ResourceLoader.exists(path):
		sprite.sprite_frames = load(path)
		sprite.play("idle")
	else:
		print("Missing animation for fruit type: ", fruit_type)
