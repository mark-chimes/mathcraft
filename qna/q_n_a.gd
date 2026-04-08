extends Node2D
class_name QnA

signal answer_correct

@export var question_generator: QuestionGenerator

var current_question : QuestionData

@onready var question_display = $QuestionDisplay
@onready var result_display = $ResultDisplay
	
func _ready(): 
	if question_generator != null: 
		generate_question()
	
func generate_question(): 
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
	if Input.is_action_just_pressed("left"):
		press_direction(true)
	elif Input.is_action_just_pressed("right"):
		press_direction(false)
		
func press_num(num):
	if current_question.answer_type != QuestionData.AnswerType.INTEGER:
		return
	var is_correct = ( num == current_question.correct_answer)
	result_display.display_arithmetic_result(is_correct, current_question, str(num))
	if is_correct:
		answer_correct.emit()
		generate_question()

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
