extends Node2D
signal success
signal add_xp(xp)
signal failure

var correct_answer = -1
var question_text = ""
var answer_text = ""

@onready var OldQuans = preload("res://old_quans.tscn")

func _init() -> void:
	pass
	
func _ready(): 
	generate_question()
	# $AnswerBox/Label.text = ""
	
func _process(delta) -> void: 
	# only goes up to 9
	for x in range(0,10): 
		if Input.is_action_just_pressed("num" + str(x)):
			press_num(x)

func press_num(num):
	print("Pressed number: " + str(num))

	answer_text = str(num)
	
	if num == correct_answer: 
		success.emit()
		add_xp.emit(420)
		show_old_quans(true)

		generate_question()
	else: 
		show_old_quans(false)

		failure.emit()	
	

func show_old_quans(is_correct): 
	var old_quans = OldQuans.instantiate()
	old_quans.position.x = 6
	old_quans.position.y = 80
	
	old_quans.set_qa(is_correct, question_text, answer_text)
	add_child(old_quans)

func generate_question(): 
	var firstnum = randi_range(0,9)
	var secondnum = randi_range(0, 9-firstnum)
	
	question_text = str(firstnum) + " + " + str(secondnum)
	$Question/Label.text = question_text
	correct_answer = firstnum + secondnum
	 
