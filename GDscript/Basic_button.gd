extends TextureButton

func _on_TextureButton_pressed3() -> void:
	disabled = true
	$ClickSound.play()
	await $ClickSound.finished

	if get_tree():
		get_tree().change_scene_to_file("res://scenes/Feed_Mochi.tscn")
