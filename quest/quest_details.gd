class_name QuestDetails  
extends Resource

@export var quest_id : String
@export var quest_title : String
@export_multiline var quest_description : String
@export var question_generator: QuestionGenerator
@export var item_mods : Dictionary[ItemData, int] = {}
@export var yield_specifiers: Array[YieldSpecifier] # Special item yields
@export var punish_on_wrong: bool  = false
# does the quest punish if the player answers wrong

# delete the quest based on this
@export var delete_quest_item_requirements: Array[ItemData]

@export var unlock_requirements : QuestUnlockRequirements #NOTE: Optional
