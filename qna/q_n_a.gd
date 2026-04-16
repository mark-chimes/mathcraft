extends Node
class_name QnA

signal answer_correct
signal answer_wrong

@export var question_generator: QuestionGenerator

var current_question : QuestionData

@export var question_display : QuestionDisplay
@export var result_display : ResultDisplay
	
var num_digits_typed = 0
var player_answer : int = 0

func _ready(): 
	if question_generator != null: 
		generate_question()
		
func set_question_timed_out(): 
	pass
	# TODO

func remove_question_timeout(): 
	pass
	# TODO

func generate_question(): 
	num_digits_typed = 0
	if question_generator == null: 
		printerr("QnA Question Generator is null")
		return
	current_question = question_generator.generate()
	update_display()

func _process(delta) -> void: 
	# only goes up to 9
	for x in range(0,10): 
		if Input.is_action_just_pressed("num" + str(x)):
			press_num(x)
	if Input.is_action_just_pressed("backspace"):
		press_back()
	if Input.is_action_just_pressed("left"):
		press_direction(true)
	elif Input.is_action_just_pressed("right"):
		press_direction(false)


func press_back(): 
	if current_question.answer_type != QuestionData.AnswerType.INTEGER:
		return
	if num_digits_typed <= 0: 
		return 
	
	player_answer = int(player_answer /10)
	num_digits_typed -= 1
	update_display()
	
func submit_answer(player_answer): 
	var is_correct = ( player_answer  == current_question.correct_answer)
	var player_answer_string = str(player_answer)
	if is_correct:
		if current_question.correct_answer == 69: 
			player_answer_string += " nice"
		elif current_question.correct_answer == 67: 
			player_answer_string = "six seven"
	else: 
		answer_wrong.emit()
	result_display.display_arithmetic_result(is_correct, current_question, player_answer_string)
	if is_correct:
		answer_correct.emit()
		generate_question()
	else: 
		answer_wrong.emit()
	reset_input()

func reset_input(): 
	num_digits_typed = 0
	player_answer = 0
	
func update_display():	
	if (num_digits_typed == 0):
		question_display.display_question(current_question, "")
	else: 
		question_display.display_question(current_question, str(player_answer))
		
func press_num(num):
	if current_question.answer_type != QuestionData.AnswerType.INTEGER:
		return
	var answer_digits = str(current_question.correct_answer).length()
	
	# Special case: single-digit answer, player types zero
	if num == 0 and num_digits_typed == 0 and answer_digits == 1: 
		num_digits_typed = 1
		submit_answer(0)
		update_display()
		
	# Special case: leading zero. Overwrite
	if num_digits_typed == 1 and player_answer == 0:
		player_answer = num
		num_digits_typed = 1
		update_display()
		return 

	# Normal case
	num_digits_typed += 1
	player_answer = player_answer * 10 + num

	if num_digits_typed >= answer_digits: 
		submit_answer(player_answer)
	update_display()
	return

func press_direction(is_left): 
	if current_question.answer_type != QuestionData.AnswerType.COMPARISON:
		return
	var is_correct = (is_left == current_question.correct_answer)
	result_display.display_comparison_result(is_correct, current_question)
	if is_correct:
		answer_correct.emit()
		generate_question()
	else: 
		answer_wrong.emit()

func switch_question_generator(new_question_generator: QuestionGenerator) -> void:
	question_generator = new_question_generator
	if is_node_ready(): 
		generate_question()
