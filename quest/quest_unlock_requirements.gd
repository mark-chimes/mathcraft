extends Resource
class_name QuestUnlockRequirements

@export var completed_quests : Array[StringName] = [] #quest IDs
@export var required_resources: Dictionary[StringName, int] = {} #item IDs -> qty

func is_unlocked(stock_control: StockControl, quest_manager: QuestManager) -> bool: 
	var are_quests_complete = quest_manager.are_quests_completed(completed_quests)
	var has_required_resources = stock_control.has_required_resources(required_resources)
	return are_quests_complete and has_required_resources
