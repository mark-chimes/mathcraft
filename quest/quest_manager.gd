extends Node

@export var quest_display : Control
@export var initial_quest_details: Array[QuestDetails]

var quest_activities: Array[QuestActivityInfo]
var active_quest: QuestActivityInfo

func _ready(): 
	for quest_details in initial_quest_details: 
		var quest_activity = QuestActivityInfo.new()
		quest_activity.is_active = false
		quest_activity.progress = 0
		quest_activity.quest = quest_details
		quest_activities.append(quest_activity)
	quest_activities[0].is_active = true
	await quest_display.ready
	quest_display.initialize_with_quest_activity(quest_activities)
