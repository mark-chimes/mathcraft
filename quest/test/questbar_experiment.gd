extends Node2D

@export var quest_display: QuestGroupDisplay

@export var quest1: QuestDetails

var activity1 : ActivityInfo

func _ready() -> void: 
	activity1 =  ActivityInfo.new()
	activity1.quest = quest1
	activity1.has_resources = true
	activity1.is_active = true
	activity1.pressure = 0.0
	
	var activities: Array[ActivityInfo] = [activity1]
	
	if not quest_display.is_node_ready():
		await quest_display.ready
		
	$QuestProgressor.refresh_display_for_activity.connect(_on_quest_progressor_refresh)
	$QuestProgressor.quest_complete.connect(_on_quest_complete)
	quest_display.initialize_with_quest_activity(activities)
	quest_display.refresh()

func _process(delta: float) -> void:
	$QuestProgressor.process_activity(activity1, delta)

func _on_qn_a_answer_correct(): 
	$QuestProgressor.on_correct_answer(activity1)

func _on_quest_progressor_refresh(activity): 
	quest_display.refresh()

func _on_quest_complete(activity: ActivityInfo): 
	pass
