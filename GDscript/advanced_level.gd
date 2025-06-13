extends TextureButton


func _process(delta: float) -> void:
	pass


func _on_TextureButton_pressed() -> void:
	GameState.level = "advanced"
	disabled = true
	$ClickSound.play()
	await $ClickSound.finished

	
	if get_tree():
		get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_pressed() -> void:
	pass # Replace with function body.
