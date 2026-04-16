extends Control
class_name QuestionDisplay

func display_question(question: QuestionData, player_answer_string): 
	$QuestionLabel.text = "  " + question.question_text 
	$AnswerLabel.text = " = " + player_answer_string
	$QuestionDescriptionLabel.text = question.question_description
	
func set_question_timed_out() -> void: 
	$QuestionLabel.modulate = Color(.6,0.2,1,.8)
	
func remove_question_timed_out() -> void: 
	$QuestionLabel.modulate = Color(1,1,1,1)
