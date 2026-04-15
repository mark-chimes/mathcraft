extends Node
class_name QnA

signal answer_correct

@export var question_generator: QuestionGenerator

var current_question : QuestionData

@export var question_display : QuestionDisplay
@export var result_display : ResultDisplay
	
var num_digits_typed = 0

func _ready(): 
	if question_generator != null: 
		generate_question()
	
func generate_question(): 
	num_digits_typed = 0
	if question_generator == null: 
		printerr("QnA Question Generator is null")
		return
	current_question = question_generator.generate()
	question_display.display_question(current_question, "")

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

var player_answer : int = 0

func press_back(): 
	if current_question.answer_type != QuestionData.AnswerType.INTEGER:
		return
	if not current_question.should_display_player_answer:
		return
	if num_digits_typed <= 0: 
		return 
	
	player_answer = int(player_answer /10)
	num_digits_typed -= 1
	if num_digits_typed == 0: 
		question_display.display_question(current_question, "")
	else: 
		question_display.display_question(current_question, str(player_answer))
		
func press_num(num):
	if current_question.answer_type != QuestionData.AnswerType.INTEGER:
		return
		
	if num_digits_typed == 0 and num == 0: 
		if current_question.correct_answer == 0: 
			result_display.display_arithmetic_result(true, current_question, str(0))
			answer_correct.emit()
			generate_question() 
		return
			
	num_digits_typed += 1
	player_answer = player_answer * 10 + num
	var answer_digits = str(current_question.correct_answer).length()

	if num_digits_typed >= answer_digits: 
		var is_correct = ( player_answer  == current_question.correct_answer)
		result_display.display_arithmetic_result(is_correct, current_question, str( player_answer))
		if is_correct:
			answer_correct.emit()
			generate_question()
			
		num_digits_typed = 0
		player_answer = 0
	if (player_answer == 0):
		question_display.display_question(current_question, "")
	else: 
		question_display.display_question(current_question, str(player_answer))
	return

func press_direction(is_left): 
	if current_question.answer_type != QuestionData.AnswerType.COMPARISON:
		return
	var is_correct = (is_left == current_question.correct_answer)
	result_display.display_comparison_result(is_correct, current_question)
	if is_correct:
		answer_correct.emit()
		generate_question()

func switch_question_generator(new_question_generator: QuestionGenerator) -> void:
	question_generator = new_question_generator
	if is_node_ready(): 
		generate_question()
