extends QuestionGenerator
class_name ArithmeticGenerator

enum Operator {ADD, MINUS, COMPARE}
@export var question_type : Operator
@export var digits: int = 0

func generate() -> QuestionData:
	match(question_type):
		Operator.ADD: return generate_addition() 
		Operator.MINUS: return generate_single_digit_subtraction()
		Operator.COMPARE: return generate_single_digit_comparison()
		_: return super.generate()

func generate_addition() -> QuestionData: 
	if digits == 2:
		var maybe = randi_range(0,2)
		if maybe == 0: 
			return generate_double_digit_addition()
		elif maybe == 1: 
			return generate_six_seven()
		else: 
			return generate_sixty_nine()
	return generate_single_digit_addition()
	
func generate_single_digit_addition() -> QuestionData:	
	var q = QuestionData.new()
	q.answer_type = QuestionData.AnswerType.INTEGER
	q.question_description = question_description
	
	var firstnum = randi_range(0,9)
	var secondnum = randi_range(0, 9-firstnum)
	
	q.question_text = str(firstnum) + " + " + str(secondnum)
	q.correct_answer = firstnum + secondnum
	return q

func generate_sixty_nine() -> QuestionData: 
	var q = QuestionData.new()
	q.answer_type = QuestionData.AnswerType.INTEGER
	q.question_description = question_description
	
	var firstnum = randi_range(0,69)
	var secondnum = 69-firstnum
	
	q.question_text = str(firstnum) + " + " + str(secondnum)
	q.correct_answer = firstnum + secondnum
	print("Generated question: " + str(q))
	print(" -- question_text " + str(q.question_text))
	print(" -- correct_answer " + str(q.correct_answer))

	return q

func generate_six_seven() -> QuestionData: 
	var q = QuestionData.new()
	q.answer_type = QuestionData.AnswerType.INTEGER
	q.question_description = question_description
	
	var firstnum = randi_range(0,67)
	var secondnum = 67-firstnum
	
	q.question_text = str(firstnum) + " + " + str(secondnum)
	q.correct_answer = firstnum + secondnum
	print("Generated question: " + str(q))
	print(" -- question_text " + str(q.question_text))
	print(" -- correct_answer " + str(q.correct_answer))

	return q
		

func generate_double_digit_addition() -> QuestionData: 
	var q = QuestionData.new()
	q.answer_type = QuestionData.AnswerType.INTEGER
	q.question_description = question_description
	
	var firstnum = randi_range(0,99)
	var secondnum = randi_range(0, 99-firstnum)
	
	q.question_text = str(firstnum) + " + " + str(secondnum)
	q.correct_answer = firstnum + secondnum
	print("Generated question: " + str(q))
	print(" -- question_text " + str(q.question_text))
	print(" -- correct_answer " + str(q.correct_answer))

	return q
	
func generate_single_digit_subtraction() -> QuestionData: 	
	var q = QuestionData.new()
	q.answer_type = QuestionData.AnswerType.INTEGER
	q.question_description = question_description

	var firstnum = randi_range(0,9)
	var secondnum = randi_range(0, firstnum)
	
	q.question_text = str(firstnum) + " - " + str(secondnum)
	q.correct_answer = firstnum - secondnum
	return q

func generate_single_digit_comparison() -> QuestionData:
	var q = QuestionData.new()
	q.answer_type = QuestionData.AnswerType.COMPARISON
	q.question_description = question_description

	var is_left_more = randi_range(0,1) == 1
	var rightnum 
	var leftnum
	if is_left_more:
		leftnum = randi_range(1,9)
		rightnum = randi_range(0, leftnum-1)
	else: 
		rightnum = randi_range(1,9)
		leftnum = randi_range(0, rightnum-1)

	q.question_text = str(leftnum) + " >< " + str(rightnum)
	q.correct_answer = is_left_more
	if is_left_more: 
		q.answer_display_text = str(leftnum) + " >  " + str(rightnum)
	else: 
		q.answer_display_text = str(leftnum) + "  < " + str(rightnum)
	return q
