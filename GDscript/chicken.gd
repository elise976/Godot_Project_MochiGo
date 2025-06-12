extends CharacterBody2D

@onready var anim = $AnimatedSprite2D



var speed = 30.0
var current_direction = Vector2.RIGHT
var action_timer := 0.0
var action_duration := 2.0
var current_action := "walk" # "stand", "walk", "nest"

func _ready():
	pick_new_action()

func _physics_process(delta):
	action_timer -= delta
	if action_timer <= 0:
		pick_new_action()
	if current_action == "walk":
		velocity = current_direction*speed
		var collision = move_and_collide(velocity*delta)
		if collision:
			current_direction = -current_direction
	

func pick_new_action():
	action_timer = randf_range(2.0, 4.0)
	var actions = ["idle", "walk", "nest"]
	current_action = actions[randi() % actions.size()]

	match current_action:
		"idle":
			anim.animation = "idle"
			anim.play()
			current_direction = Vector2.ZERO
		"walk":
			anim.animation = "walk"
			anim.play()
			current_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
		"nest":
			anim.animation = "nest"
			anim.play()
			current_direction = Vector2.ZERO
