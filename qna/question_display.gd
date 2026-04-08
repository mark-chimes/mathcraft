extends Node2D

func display_question(question: QuestionData): 
	$Label.text = question.question_text
	$QuestionDescriptionLabel.text = question.question_description
