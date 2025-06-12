extends Node

@onready var result_label = $ResultLabel

func _ready():
	result_label.text = GameState.result_text
	
