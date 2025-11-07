extends Node

@onready var question_label = $Label/QuestionLabel
@onready var answer_input = $AnswerLineEdit
@onready var character = $Mochi
@onready var stone_positions = $StoneContainer.get_children()
@onready var response_label = $Label/ResponseLabel  
@onready var countdown_label = $Label/CountdownLabel
@onready var fruit_count_label = $CanvasLayer/FruitCountLabel


var keep_editing_on_text_submitted: bool = true

var current_question = ""
var correct_answer = 0
var total_questions = 20 
var question_count = 0
var current_stone = 0
var countdown_time
var is_counting = true

func _ready():
	randomize()
	load_question()
	answer_input.editable = true
	answer_input.connect("text_submitted", Callable(self, "_on_answer_submitted"))

	BgmPlayer.stop_music()

	if GameState.level == "basic":
		countdown_time = 60
	elif GameState.level == "advanced":
		countdown_time = 100
	



func generate_basic_question():
	var a = 1+randi() % 15 # 0~15
	var b = 1+randi() % 16  # 0~15
	var operators = ["+", "-"]
	var op = operators[randi() % operators.size()]

	if op == "+":
		correct_answer = a + b
	
		while correct_answer > 15:
			a = randi() % 16
			b = randi() % 16
			correct_answer = a + b
	else:
		
		if a < b:
			var temp = a
			a = b
			b = temp
		correct_answer = a - b

	current_question = str(a) + " " + op + " " + str(b)
	
func generate_advanced_question():
	var ops = ["+", "-", "*", "/"]
	var op1 = ops[randi() % ops.size()]
	var op2 = ops[randi() % ops.size()]
	var use_brackets = randi() % 2 == 0  # 50% chance

	var a = 1 + randi() % 20
	var b = 1 + randi() % 20
	var c = 1 + randi() % 10

	# Ensure division gives whole number
	if op1 == "/":
		b = 1 + randi() % 10
		a = b * (1 + randi() % 5)
	if op2 == "/":
		c = 1 + randi() % 10
		b = c * (1 + randi() % 5)

	var expr = ""
	if use_brackets:
		if randi() % 2 == 0:
			expr = "({0} {1} {2}) {3} {4}".format([a, op1, b, op2, c])
		else:
			expr = "{0} {1} ({2} {3} {4})".format([a, op1, b, op2, c])
	else:
		expr = "{0} {1} {2} {3} {4}".format([a, op1, b, op2, c])
	
	var eval_expr = expr.replace(str(a), str(a)+".0")
	# Replace symbols for German notation
	var display_expr = expr.replace("*", "·").replace("/", ":")
	#var eval_expr = expr.replace(":", "/").replace("·", "*")
	var expression = Expression.new()
	expression.parse(eval_expr)
	correct_answer = expression.execute()
	#print("Evaluating:", eval_expr, " = ", correct_answer)

	
	if correct_answer < 0 or correct_answer != int(correct_answer) or correct_answer > 500:
		return generate_advanced_question()
	correct_answer = int(correct_answer)
	current_question = display_expr

	


func load_question():
	answer_input.text = ""
	answer_input.grab_focus()
	#generate_question()
	if GameState.level == "advanced":
		generate_advanced_question()
	else:
		generate_basic_question()
	
	question_label.text = current_question + " = ?"
	response_label.text = ""
	answer_input.editable = true

func _on_answer_submitted(text):
	if text.is_valid_float() and "." not in text and text.strip_edges() != "":
		var user_answer = int(text)

		if user_answer == correct_answer:
			response_label.text = "Richtig!"
			move_character(1)
			$Sound/CorrectAnswer.play()
		else:
			response_label.text = "Falsch!"
			move_character(-1)
			$Sound/FalseAnswer.play()

		await get_tree().create_timer(0.5).timeout
		next_question()
		if keep_editing_on_text_submitted:
			answer_input.call_deferred("edit")

func next_question():
	load_question()

func move_character(direction):
	current_stone += direction
	current_stone = clamp(current_stone, 0, stone_positions.size() - 1)
	character.position = stone_positions[current_stone].position
	
	if current_stone == stone_positions.size() - 1:
		$Sound/FinishSound.play()
		await $Sound/FinishSound.finished
		go_to_final_page("Glückwunsch! Gewonnen!🎉")

func _on_time_up():
	question_label.text = "Time's up!"
	answer_input.editable = false
	go_to_final_page("Du kannst es besser!^_^")

func _process(delta: float):
	fruit_count_label.text = "🍎 %d" % GameState.fruit_count
	if is_counting:
		countdown_time -= delta
		if countdown_time <= 0:
			countdown_time = 0
			is_counting = false
			_on_time_up()
		countdown_label.text = "⏱ " + str(round(countdown_time)) + "s"


func _on_ExitButton_pressed() -> void:
	$Sound/ClickSound.play()
	await $Sound/ClickSound.finished
	if get_tree():
		get_tree().change_scene_to_file("res://scenes/ui.tscn")
	
func go_to_final_page(result_text: String):
	GameState.result_text = result_text

	get_tree().change_scene_to_file("res://scenes/WinLose_Final_Page.tscn")


	
