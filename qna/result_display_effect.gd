extends Node2D

var alpha_amount = 1.0
@export var fade_seconds = 4.0
@export var vert_speed = 20

var text = null

@onready var label = $QuestAnsLabel

func _process(delta):
	alpha_amount = max(alpha_amount - delta/fade_seconds, 0.0)
	position.y += delta/fade_seconds*vert_speed
	modulate.a = alpha_amount
	
	if alpha_amount == 0.0:
		queue_free()

func set_qa(is_correct, question_string, answer_string): 
	text = question_string + " = " + answer_string
	modulate.b = 0.0
	if is_correct: 
		text = question_string + " = " + answer_string
		modulate.r = 0.0
	else: 
		text = question_string + " ≠ " + answer_string
		modulate.g = 0.0
	label.text = text

func set_qa_comp(is_correct, correct_string): 
	text = correct_string
	modulate.b = 0.0
	if is_correct: 
		modulate.r = 0.0
	else: 
		modulate.g = 0.0
	label.text = text
