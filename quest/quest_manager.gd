extends Node

@export var quest_display : QuestGroupDisplay
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
	active_quest = quest_activities[0]
	active_quest.is_active = true
	await quest_display.ready
	quest_display.initialize_with_quest_activity(quest_activities)

func _on_quest_group_display_quest_activated(quest_activity: QuestActivityInfo) -> void:
	print("Quest active! " + quest_activity.quest.quest_title)

func _on_timer_timeout() -> void:
	print("GOT TIMER TIMEOUT!")
	active_quest.progress = 500.0
	quest_display.refresh_display_for_quest(active_quest)
