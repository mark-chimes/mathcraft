extends Node

@export var quest_display : QuestGroupDisplay
@export var initial_quest_details: Array[QuestDetails]

var quest_activities: Array[QuestActivityInfo]
var active_quest: QuestActivityInfo

func _ready(): 
	if initial_quest_details.is_empty():
		return
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

func _on_quest_group_display_quest_activated(activated_quest: QuestActivityInfo) -> void:
	activate_quest(activated_quest)
	refresh_quest_display()
	

func refresh_quest_display(): 
	quest_display.refresh()

func activate_quest(new_quest): 
	# TODO QnA question generation
	if new_quest == null: 
		deactivate_all_quests()
		return
	
	new_quest.is_active = true
	active_quest = new_quest
	for quest in quest_activities: 
		if quest!= new_quest:
			quest.is_active = false

func deactivate_all_quests(): 
	for quest in quest_activities: 
		quest.is_active = false

func remove_quest(activity: QuestActivityInfo): 
	if not quest_activities.has(activity): 
		printerr("Quest not found")
		return
	# len(quest_activies) == 0 not possible by previous check
			
	quest_activities.erase(activity)
	quest_display.remove_quest(activity)
	
	if quest_activities.is_empty():
		deactivate_all_quests()
	else: 
		var new_active_quest = quest_activities[0]
		activate_quest(new_active_quest)
	
	refresh_quest_display()
	

func _on_timer_timeout() -> void:
	active_quest.progress = 500.0
	quest_display.refresh_display_for_quest(active_quest)
	remove_quest(quest_activities[1])

func _on_timer_2_timeout() -> void:
	remove_quest(quest_activities[0])
