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
	question_display.display_question(current_question)

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
	if not current_question.should_display_player_answer:
		return
	if num_digits_typed <= 0: 
		return 
	
	current_question.player_answer = int(current_question.player_answer /10)
	num_digits_typed -= 1
	question_display.display_question(current_question)

func press_num(num):
	if current_question.answer_type != QuestionData.AnswerType.INTEGER:
		return
		
	if current_question.should_display_player_answer:
		if num_digits_typed == 0 and num == 0: 
			if current_question.correct_answer == 0: 
				result_display.display_arithmetic_result(true, current_question, str(0))
				answer_correct.emit()
				generate_question() 
			return
				
		num_digits_typed += 1
		var old_answer = current_question.player_answer
		
		current_question.player_answer = old_answer*10 + num
		print("current_question.player_answer: " + str(current_question.player_answer))
		print("num_digits_typed: " + str(num_digits_typed))
		print("current_question.answer_digits: " + str(current_question.answer_digits))

		if num_digits_typed >= current_question.answer_digits: 
			var is_correct = ( current_question.player_answer  == current_question.correct_answer)
			print("is_correct: " + str(is_correct))

			result_display.display_arithmetic_result(is_correct, current_question, str( current_question.player_answer))
			if is_correct:
				answer_correct.emit()
				generate_question()
				return
			num_digits_typed = 0
			current_question.player_answer = 0
			return 
		question_display.display_question(current_question)
		return

	else: 
		var is_correct = ( num == current_question.correct_answer)
		result_display.display_arithmetic_result(is_correct, current_question, str(num))
		if is_correct:
			answer_correct.emit()
			generate_question() 
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
