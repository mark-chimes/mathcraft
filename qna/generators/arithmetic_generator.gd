class_name ArithmeticGenerator
extends QuestionGenerator

enum Operator {ADD, MINUS, COMPARE}
@export var question_type : Operator

func generate() -> QuestionData:
	var q = QuestionData.new()

	match(question_type):
		Operator.ADD: return generate_single_digit_addition()
		Operator.MINUS: return generate_single_digit_subtraction()
		Operator.COMPARE: return generate_single_digit_comparison()
		_: return super.generate()
		
func generate_single_digit_addition() -> QuestionData:
	var q = QuestionData.new()
	q.answer_type = QuestionData.AnswerType.INTEGER

	var firstnum = randi_range(0,9)
	var secondnum = randi_range(0, 9-firstnum)
	
	q.question_text = str(firstnum) + " + " + str(secondnum)
	q.correct_answer = firstnum + secondnum
	return q
	
func generate_single_digit_subtraction() -> QuestionData: 	
	var q = QuestionData.new()
	q.answer_type = QuestionData.AnswerType.INTEGER

	var firstnum = randi_range(0,9)
	var secondnum = randi_range(0, firstnum)
	
	q.question_text = str(firstnum) + " - " + str(secondnum)
	q.correct_answer = firstnum - secondnum
	return q

func generate_single_digit_comparison() -> QuestionData:
	var q = QuestionData.new()
	q.answer_type = QuestionData.AnswerType.COMPARISON

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
	return q
