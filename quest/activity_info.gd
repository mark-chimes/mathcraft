class_name ActivityInfo  

var quest : QuestDetails
var progress : float = 0.0
var is_focused: bool = false
var has_resources: bool = false # Whether this quest can be completed based on resources
var completion_times: int = 0
var pressure: float = 0.0 # how much progress per second TODO SAVE THIS

# TODO Incorporate into save system
var timeout_remaining_ms : int = 0

var quest_title:
	get: return quest.quest_title
