extends Area2D

@onready var anim_sprite = $AnimatedSprite2D
@export var fruit_type: String = "apple"

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	_loadanimation()

func _loadanimation():
	var sprite = $AnimatedSprite2D
	var path = "res://fruits/%s_frames.tres" % fruit_type
	if ResourceLoader.exists(path):
		sprite.sprite_frames = load(path)
		sprite.play("idle")
	else:
		print("Missing animation for fruit type: ", fruit_type)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		print("Picked up fruit: ", self.name)
		queue_free()
