class_name NonGenerator
extends QuestionGenerator

# The null question generator that doesn't generate a non-question

func generate() -> QuestionData:
	var q = QuestionData.new()
	q.answer_type = QuestionData.AnswerType.NONE
	q.question_text = "No quest active"
	q.correct_answer = "no"
	return q
