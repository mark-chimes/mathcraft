extends Node2D


@onready var ResultDisplayEffect := preload("res://qna/result_display_effect.tscn")

var cur_effect : Node2D = null

func display_result(is_correct: bool, question_data: QuestionData, player_answer_string: String): 
	if cur_effect != null: 
		cur_effect.queue_free()
	cur_effect = ResultDisplayEffect.instantiate()
	add_child(cur_effect)
	cur_effect.set_qa(is_correct, question_data.question_text, player_answer_string)
