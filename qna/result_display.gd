extends Control
class_name ResultDisplay

@export var result_display_effect: PackedScene # := preload("res://qna/result_display_effect.tscn")

var cur_effect : Node2D = null

func display_arithmetic_result(is_correct: bool, question_data: QuestionData, player_answer_string: String): 
	if cur_effect != null: 
		cur_effect.queue_free()
	cur_effect = result_display_effect.instantiate()
	add_child(cur_effect)
	cur_effect.set_qa(is_correct, question_data.question_text, player_answer_string)

func display_comparison_result(is_correct: bool, question_data: QuestionData): 
	if cur_effect != null: 
		cur_effect.queue_free()
	cur_effect = result_display_effect.instantiate()
	add_child(cur_effect)
	cur_effect.set_qa_comp(is_correct,  question_data.answer_display_text)
 
func display_timeout(): 
	cur_effect = result_display_effect.instantiate()
	add_child(cur_effect)
	cur_effect.display_text_red("TIMED OUT!")
