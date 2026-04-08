class_name QuestionData

enum AnswerType { 
	NONE, INTEGER, COMPARISON
}

var question_description: String

var question_text : String
var answer_type : AnswerType
var correct_answer # depends on AnswerType
var answer_display_text : String # optional, depending on AnswerType
