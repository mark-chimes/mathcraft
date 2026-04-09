class_name QuestDetails  
extends Resource

@export var quest_id : String
@export var quest_title : String
@export_multiline var quest_description : String
@export var question_generator: QuestionGenerator
@export var item_mods : Dictionary[ItemData, int] = {}
@export var yield_specifiers: Array[YieldSpecifier] # Special item yields

@export var unlock_requirements : QuestUnlockRequirements #NOTE: Optional
