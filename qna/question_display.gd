extends Control
class_name QuestionDisplay

func display_question(question: QuestionData, player_answer_string): 
	$Label.text = "  " + question.question_text 
	$AnswerLabel.text = " = " + player_answer_string
	$QuestionDescriptionLabel.text = question.question_description
	
