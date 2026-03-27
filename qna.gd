extends Node2D

func _init() -> void:
	pass
	
func _ready(): 
	$AnswerBox/Label.text = "|"
	
func _process(delta) -> void: 
	# only goes up to 9
	for x in range(0,10): 
		if Input.is_action_just_pressed("num" + str(x)):
			press_num(x)

func press_num(num):
	print("Pressed number: " + str(num))
	$AnswerBox/Label.text = str(num)
	
