extends Node2D
signal success
signal generate_berry_progress(progress)
signal generate_scavenge_progress(progress)
signal generate_craft_progress(progress)

signal failure

var correct_answer = -1
var question_text = ""
var answer_text = ""

var progress_per_answer = 80

var current_task = "scavenge"

@onready var OldQuans = preload("res://old_quans.tscn")
@export var task_button_group: ButtonGroup # Reference to your ButtonGroup resource

func _init() -> void:
	pass
	
func _ready(): 
	task_button_group.pressed.connect(_on_task_button_pressed)
	generate_question()
	# $AnswerBox/Label.text = ""
	
func _on_task_button_pressed(button: BaseButton):
	var task_name = button.name
	print("Button pressed: " + button.name)
	
	if task_name == "BerryButton": 
		current_task = "pickberries"
	elif task_name == "ScavengeButton": 
		current_task = "scavenge"
	elif task_name == "CraftButton": 
		current_task = "craft"
	else: 
		printerr("Unrecognized task name: " + task_name)
	generate_question()

func disable_crafting():
	if current_task == "craft":
		current_task = "scavenge"
		generate_question()
			
func _process(delta) -> void: 
	# only goes up to 9
	for x in range(0,10): 
		if Input.is_action_just_pressed("num" + str(x)):
			press_num(x)
	
	if Input.is_action_just_pressed("left"):
		press_left_right(false)
	elif Input.is_action_just_pressed("right"):
		press_left_right(true)

func press_left_right(is_right): 
	if is_right: 
		print("Pressed right")
	else: 
		print("Pressed left")
		
	if correct_answer == is_right: 
		success.emit()
		emit_progress() 
		show_old_quans_comp(true)

		generate_question()
	else: 
		show_old_quans_comp(false)

		failure.emit()		

func press_num(num):
	if not ( current_task == "scavenge" or current_task == "craft"):
		return
	print("Pressed number: " + str(num))

	answer_text = str(num)
	
	if num == correct_answer: 
		success.emit()
		emit_progress() 
		show_old_quans(true)

		generate_question()
	else: 
		show_old_quans(false)

		failure.emit()	
	
var cur_quans = null

func show_old_quans_comp(is_correct): 
	if cur_quans != null: 
		cur_quans.queue_free()
	var old_quans = OldQuans.instantiate()
	old_quans.position.x = 6
	old_quans.position.y = 80
	
	old_quans.set_qa_comp(is_correct, answer_text)
	cur_quans = old_quans
	add_child(old_quans)


func show_old_quans(is_correct): 
	if cur_quans != null: 
		cur_quans.queue_free()
	var old_quans = OldQuans.instantiate()
	old_quans.position.x = 6
	old_quans.position.y = 80
	
	old_quans.set_qa(is_correct, question_text, answer_text)
	cur_quans = old_quans
	add_child(old_quans)

func emit_progress(): 
	if current_task == "pickberries":
		generate_berry_progress.emit(progress_per_answer)
	elif current_task == "scavenge":
		generate_scavenge_progress.emit(progress_per_answer)
	elif current_task == "craft": 
		generate_craft_progress.emit(progress_per_answer)
	else:
		printerr("Unrecognized task: " + current_task)

func generate_question():
	if current_task == "pickberries":
		generate_comparison()
	elif current_task == "scavenge":
		generate_addition()
	elif current_task == "craft": 
		generate_subtraction()
	else:
		printerr("Unrecognized task: " + current_task)

func generate_comparison(): 
	var is_right_bigger = randi() % 2 == 0
	var firstnum
	var secondnum
	
	print("Decide right is bigger: " + str(is_right_bigger))
	
	if is_right_bigger:
		secondnum = randi_range(1,9)
		firstnum = randi_range(0,secondnum-1)
	else: 
		firstnum = randi_range(1,9)
		secondnum = randi_range(0,firstnum-1)

		
	question_text = str(firstnum) + " >< " + str(secondnum)
	$Question/Label.text = question_text
	correct_answer = is_right_bigger

	if is_right_bigger: 
		answer_text = str(firstnum) + "  < " + str(secondnum)
	else: 
		answer_text = str(firstnum) + " >  " + str(secondnum)

		
func generate_addition(): 
	var firstnum = randi_range(0,9)
	var secondnum = randi_range(0, 9-firstnum)
	
	question_text = str(firstnum) + " + " + str(secondnum)
	$Question/Label.text = question_text
	correct_answer = firstnum + secondnum
	
func generate_subtraction(): 
	var firstnum = randi_range(0,9)
	var secondnum = randi_range(0, firstnum)
	
	question_text = str(firstnum) + " - " + str(secondnum)
	$Question/Label.text = question_text
	correct_answer = firstnum - secondnum
