extends Node2D


@onready var ResultDisplayEffect := preload("res://qna/result_display_effect.tscn")

var cur_effect : Node2D = null

func display_result(is_correct: bool, question_data: QuestionData, player_answer_string: String): 
	if cur_effect != null: 
		cur_effect.queue_free()
	cur_effect = ResultDisplayEffect.instantiate()
	print("cur_effect: " + str(cur_effect))
	print("Question data: " + str(question_data.question_text) + " player_answer_string: " + str(player_answer_string) )
	cur_effect.set_qa(is_correct, question_data.question_text, player_answer_string)
	add_child(cur_effect)
