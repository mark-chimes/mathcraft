class_name QuestDetails  
extends Resource

@export var quest_id : String
@export var quest_title : String
@export_multiline var quest_description : String
@export var question_generator: QuestionGenerator
@export var item_mods : Dictionary[ItemData, int] = {}
@export var yield_specifiers: Array[YieldSpecifier] # Special item yields

@export var progress_for_upgrade_mult: float = 1.0
@export var pressure_per_answer_mult: float = 1.0

# does the quest punish if the player answers wrong
@export var punish_on_wrong: bool  = false



# delete the quest based on this
@export var delete_quest_item_requirements: Array[ItemData]

@export var unlock_requirements : QuestUnlockRequirements #NOTE: Optional
