class_name QuestionData

enum AnswerType { 
	NONE, INTEGER, COMPARISON
}

var question_description: String

var question_text : String
var answer_type : AnswerType

var should_display_player_answer: bool = false
var answer_digits: int = 0
var player_answer: int

var correct_answer # depends on AnswerType
var answer_display_text : String # optional, depending on AnswerType
