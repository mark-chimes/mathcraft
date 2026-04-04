extends Panel

@export var QuestDisplayScene : PackedScene #:= preload("res://quest/quest_display.tscn")
@export var quests_container_node : Control

func _ready(): 
	for child in quests_container_node.get_children():
		child.queue_free()

func initialize_with_quest_activity(initial_quests : Array[QuestActivityInfo]): 
	for quest_activity in initial_quests: 
		add_quest(quest_activity)

func add_quest(quest_activity: QuestActivityInfo): 
	var new_quest_display := QuestDisplayScene.instantiate()
	quests_container_node.add_child(new_quest_display)
	new_quest_display.initialize_quest_details(quest_activity)
