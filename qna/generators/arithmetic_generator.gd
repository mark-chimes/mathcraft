class_name ArithmeticGenerator
extends QuestionGenerator

enum Operator {ADD, MINUS}
@export var question_type : Operator

func generate() -> QuestionData:
	var q = QuestionData.new()

	match(question_type):
		Operator.ADD: return generate_single_digit_addition()
		Operator.MINUS: return generate_single_digit_subtraction()
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
