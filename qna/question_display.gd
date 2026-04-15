extends Control
class_name QuestionDisplay

func display_question(question: QuestionData): 
	
	if not question.should_display_player_answer: 
		$Label.text = question.question_text
	else: 
		$Label.text = question.question_text + " = " + str(question.player_answer)
	$QuestionDescriptionLabel.text = question.question_description
	
