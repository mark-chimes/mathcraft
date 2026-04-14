extends Node2D

@export var quest_display: QuestGroupDisplay

@export var quest1: QuestDetails

var activity1 : ActivityInfo

func _ready() -> void: 
	activity1 =  ActivityInfo.new()
	activity1.quest = quest1
	activity1.is_possible = true
	activity1.is_active = true
	activity1.pressure = 0.0
	
	var activities: Array[ActivityInfo] = [activity1]
	
	if not quest_display.is_node_ready():
		await quest_display.ready
		
	$QuestProgressor.initialize(activity1, quest_display)
	quest_display.initialize_with_quest_activity(activities)
	quest_display.refresh()

func _on_qn_a_answer_correct(): 
	$QuestProgressor.on_correct_answer()
