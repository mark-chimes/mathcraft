extends Node2D

@export var question_generator: QuestionGenerator

func _ready(): 
	var current_question : QuestionData = question_generator.generate()
	$QuestionDisplay.display_question(current_question)
