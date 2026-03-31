class_name QuestionData 

enum AnswerType { 
	INTEGER, COMPARISON
}

var question_text : String
var answer_type : AnswerType
var correct_answer # depends on AnswerType
