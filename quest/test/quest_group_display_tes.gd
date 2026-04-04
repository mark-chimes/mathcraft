extends Node2D

@export var quest_group_display: Control
@export var initial_quest_details : Array[QuestDetails] = []
var button_group = preload("res://quest/QuestSelectionGroup.tres")

var quest_activities = []
#func _on_timer_timeout() -> void:
	#print("TIMER 1")
	#print("Button group: " + str(button_group))
	#print("Pressed: "  + str(button_group.get_pressed_button()))
	#for quest_details in initial_quest_details: 
		#var quest_activity = QuestActivityInfo.new()
		#quest_activity.is_active = false
		#quest_activity.progress = 0
		#quest_activity.quest = quest_details
		#quest_activities.append(quest_activity)
		#quest_group_display.update_quest(quest_activity)
	#
#func _on_timer_2_timeout() -> void:
	#print("TIMER 2")
	#print("Button group: " + str(button_group))
	#print("Pressed: "  + str(button_group.get_pressed_button()))
	#quest_group_display.activate_quest(quest_activities[0])
	#
#
#func _on_timer_3_timeout() -> void:
	#print("TIMER 3")
	#print("Button group: " + str(button_group))
	#print("Pressed: "  + str(button_group.get_pressed_button()))
	#for quest_activity in quest_activities: 
		#print("REMOVING: " + str(quest_activity.quest.quest_title))
		#quest_group_display.remove_quest(quest_activity)
		#print("Button group: " + str(button_group))
		#print("Pressed: "  + str(button_group.get_pressed_button()))
		#print("---")
