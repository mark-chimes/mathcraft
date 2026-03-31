extends Node2D

@export var question_generator: QuestionGenerator
var current_question : QuestionData

func _ready(): 
	generate_question()
	
func generate_question(): 
	if question_generator == null: 
		printerr("QnA Question Generator is null")
	current_question = question_generator.generate()
	$QuestionDisplay.display_question(current_question)

func _process(delta) -> void: 
	# only goes up to 9
	for x in range(0,10): 
		if Input.is_action_just_pressed("num" + str(x)):
			press_num(x)
	
func press_num(num):
	if current_question.answer_type != QuestionData.AnswerType.INTEGER:
		return
	print("Pressed number: " + str(num))
	
	if num == current_question.correct_answer:
		print("SUCCESS!")
		generate_question()
	else: 
		print("Failure")
	
