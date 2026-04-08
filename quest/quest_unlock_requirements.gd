extends Resource
class_name QuestUnlockRequirements

@export var completed_quests : Array[StringName] = [] #quest IDs
# TODO Required resources

func is_unlocked(stock_control: StockControl, quest_manager: QuestManager) -> bool: 
	#TODO Stock control required resources
	return quest_manager.are_quests_completed(completed_quests)
