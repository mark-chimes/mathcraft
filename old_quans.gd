extends Node2D

var alpha_amount = 1.0

func _process(delta):
	alpha_amount = max(alpha_amount - delta*0.5, 0.0)
	position.y += delta*10
	modulate.a = alpha_amount
	
	if alpha_amount == 0.0:
		queue_free()

func set_qa(is_correct, question_string, answer_string): 
	$OldQuest.text = question_string + " = " + answer_string
	modulate.b = 0.0
	if is_correct: 
		modulate.r = 0.0
	else: 
		modulate.g = 0.0
