extends Node2D

@onready var fruit_count_label = $FeedUI/FruitCountLabel
@onready var sat_bar = $FeedUI/FullBar
@onready var feed_button = $FeedUI/FeedButton
@onready var no_fruit_text = $FeedUI/Feedback/NoFruit
@onready var heart1 = $FeedUI/Feedback/Heart1
@onready var heart2 = $FeedUI/Feedback/Heart2
@onready var fulltext = $FeedUI/Feedback/Fulltext
@onready var back_button = $FeedUI/BackButton
@onready var wrongsound = $FeedUI/FeedButton/WrongSound
@onready var fullsound = $FeedUI/FullSound

var sat_value :=90
var max_sat := 100
var sat_decrease_rate := 10

var sat_full_timer := 0.0  # 新增：吃饱后计时

func _ready() -> void:
	update_ui()
	heart1.visible = false
	heart2.visible = false
	no_fruit_text.visible = false
	fulltext.visible = false
	BgmPlayer.play_music()

func _process(delta: float) -> void:
	fruit_count_label.text = "Fruits: %d" % GameState.fruit_count
	
	if sat_value >= max_sat:
		sat_full_timer += delta  
	else:
		sat_full_timer = 0.0     

	
	if sat_full_timer >= 120:
		sat_value -= sat_decrease_rate * delta
		if sat_value < 0:
			sat_value = 0

	sat_bar.value = sat_value

func _on_feed_button_pressed() -> void:
	if GameState.fruit_count <= 0:
		no_fruit_text_show()
		wrongsound.play()
		return

	if sat_value >= max_sat:
		full_text_show()
		wrongsound.play()
		return

	sat_value = min(sat_value + 10, max_sat)
	GameState.fruit_count -= 1
	update_ui()
	heart_show()
	fullsound.play()

	$FeedUI/FeedButton/ClickSound.play()
	await $FeedUI/FeedButton/ClickSound.finished

func update_ui() -> void:
	fruit_count_label.text = "Fruits: %d" % GameState.fruit_count
	sat_bar.value = sat_value

func heart_show() -> void:
	heart1.visible = true
	await get_tree().create_timer(0.5).timeout
	heart1.visible = false
	heart2.visible = true
	await get_tree().create_timer(0.5).timeout
	heart2.visible = false

func no_fruit_text_show() -> void:
	no_fruit_text.visible = true
	await get_tree().create_timer(2.5).timeout
	no_fruit_text.visible = false
	heart1.visible = false
	heart2.visible = false

func full_text_show() -> void:
	fulltext.visible = true
	await get_tree().create_timer(2.5).timeout
	fulltext.visible = false
	heart1.visible = false
	heart2.visible = false

func _on_back_button_pressed() -> void:
	$FeedUI/BackButton/ClickSound.play()
	await $FeedUI/BackButton/ClickSound.finished
	get_tree().change_scene_to_file("res://scenes/ui.tscn")
