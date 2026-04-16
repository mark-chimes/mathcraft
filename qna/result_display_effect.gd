extends Node2D

var alpha_amount = 1.0
@export var fade_seconds = 4.0
@export var hor_speed = 2000

@export var gravity = 200
var vert_speed = 0

var text = null

@onready var label = $QuestAnsLabel

func _process(delta):
	alpha_amount = max(alpha_amount - delta/fade_seconds, 0.0)
	vert_speed += gravity * delta
	position.y += delta*vert_speed
	position.x += delta/(fade_seconds*fade_seconds)*hor_speed

	modulate.a = alpha_amount
	
	if alpha_amount == 0.0:
		queue_free()

func display_text_red(special_text): 
	modulate = Color(.6,0.2,1)
	label.text = special_text

func set_qa(is_correct, question_string, answer_string): 
	modulate.b = 0.0
	if is_correct: 
		#text = question_string + " = " + answer_string
		#text = "= " + answer_string
		modulate.r = 0.0
	else: 
		#text = question_string + " ≠ " + answer_string
		#text = "≠ " + an1swer_string
		modulate.g = 0.0
	label.text = answer_string

func set_qa_comp(is_correct, correct_string): 
	text = correct_string
	modulate.b = 0.0
	if is_correct: 
		modulate.r = 0.0
	else: 
		modulate.g = 0.0
	label.text = text
