class_name ActivityInfo  

var quest : QuestDetails
var progress : int = 0
var is_active: bool = false
var is_possible: bool = false # Whether this quest can be completed based on resources
var completion_times: int = 0
var pressure: float = 0.0 # how much progress per second TODO SAVE THIS

var quest_title:
	get: return quest.quest_title
