extends Resource
class_name QuestSaveData

@export var quests_progress : Dictionary[StringName, int] = {}
@export var quests_pressure : Dictionary[StringName, int] = {}
@export var quests_completion_number : Dictionary[StringName, int] = {} 
@export var active_quest_id: StringName
