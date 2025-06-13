extends Node2D

@onready var fruit_count_label = $FeedUI/FruitCountLabel
@onready var sat_bar = $FeedUI/FullBar             
@onready var feed_button = $FeedUI/FeedButton
@onready var no_fruit_text = $FeedUI/Feedback/NoFruit
@onready var heart1 = $FeedUI/Feedback/Heart1
@onready var heart2 = $FeedUI/Feedback/Heart2
@onready var fulltext = $FeedUI/Feedback/Fulltext
@onready var back_button=$FeedUI/BackButton
@onready var bgm=$AudioStreamPlayer


var sat_value = 50          
var max_sat = 100
var sat_decrease_rate = 10   

func _ready() -> void:
	update_ui()
	heart1.visible = false
	heart2.visible = false
	no_fruit_text.visible = false
	fulltext.visible = false
	bgm.play()

func _process(delta: float) -> void:
	fruit_count_label.text = "Fruits: %d" % GameState.fruit_count

	if sat_value >= max_sat:
		sat_value -= sat_decrease_rate * delta
		if sat_value < 0:
			sat_value = 0
	
	sat_bar.value = sat_value

func _on_feed_button_pressed() -> void:
	feed_pet()
	$FeedUI/FeedButton/ClickSound.play()
	await $FeedUI/FeedButton/ClickSound.finished

func feed_pet() -> void:
	if GameState.fruit_count > 0 and sat_value < max_sat:
		sat_value = min(sat_value + 10, max_sat)
		GameState.fruit_count -= 1
		heart_show()
		$FeedUI/FullSound.play()
		update_ui()
		
		if sat_value == max_sat:
			full_text_show()
			
		if GameState.fruit_count <= 0:
			no_fruit_text_show()
			
	elif GameState.fruit_count <= 0:
		no_fruit_text_show()
	elif sat_value >= max_sat:
		full_text_show()

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

func full_text_show() -> void:
	fulltext.visible = true
	await get_tree().create_timer(2.5).timeout
	fulltext.visible = false

func _on_back_button_pressed() -> void:
	$FeedUI/BackButton/ClickSound.play()
	await $FeedUI/BackButton/ClickSound.finished
	if get_tree():
		get_tree().change_scene_to_file("res://scenes/ui.tscn")
	
