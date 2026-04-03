extends Node2D

@export var test_quest : QuestDetails

func _ready() -> void: 
	$QuestDisplay.initialize_quest_details(test_quest)
