extends Node
class_name QuestManager

@export var quest_display : QuestGroupDisplay
@export var stock_control : StockControl
@export var qna : QnA

@export var non_question: QuestionGenerator
@export var null_quest: QuestDetails

var null_activity : QuestActivityInfo

@export var initial_quest_details: Array[QuestDetails]

var quest_activities: Array[QuestActivityInfo]
var active_quest: QuestActivityInfo

@export var all_quest_details_path : String = ""


const PROGRESS_BY_ANSWER = 120
const REQUIRED_PROGRESS = 1000

signal update_quest_text(quest_details: QuestDetails)

func _ready(): 
	null_activity = QuestActivityInfo.new()
	null_activity.quest = null_quest
	null_activity.is_active = false
	null_activity.is_possible = false
	
	if initial_quest_details.is_empty():
		return
	for quest_details in initial_quest_details: 
		var quest_activity = QuestActivityInfo.new()
		quest_activity.is_active = false
		quest_activity.progress = 0
		quest_activity.quest = quest_details
		quest_activities.append(quest_activity)
	
	var first_quest = quest_activities[0]
	first_quest.is_possible = true
	activate_quest(first_quest)
	
	if not stock_control.is_node_ready():
		await stock_control.ready
	update_quest_possibility()

	if not quest_display.is_node_ready():
		await quest_display.ready
	quest_display.initialize_with_quest_activity(quest_activities)
	refresh_quest_display()
	

func update_quest_possibility(): 
	for activity in quest_activities: 
		activity.is_possible = true
		var item_mods = activity.quest.item_mods
		for item in item_mods: 
			var required_qty = - item_mods[item] # note negative
			if required_qty > 0:
				var stock_qty = stock_control.get_qty_for(item)
				if stock_qty < required_qty: 
					print("Quest " + activity.quest.quest_title + " not possible due to resource constraints")
					activity.is_possible = false
					if activity.is_active: 
						quest_display_deplete_quest(activity)
	if not active_quest.is_possible: 
		deactivate_all_quests()
		#activate_quest(quest_activities[0])
	
func _on_quest_group_display_quest_activated(activated_quest: QuestActivityInfo) -> void:
	activate_quest(activated_quest)
	refresh_quest_display()

func quest_display_deplete_quest(activity): 
	quest_display.spawn_quest_depletion_effect(activity)
	
func refresh_quest_display(): 
	emit_update_quest_text()
	quest_display.refresh()

func activate_quest(new_quest : QuestActivityInfo): 
	if not is_questable(new_quest): 
		return
	new_quest.is_active = true
	active_quest = new_quest
	qna.switch_question_generator(active_quest.quest.question_generator)
	for quest in quest_activities: 
		if quest!= new_quest:
			quest.is_active = false

func emit_update_quest_text(): 
	if active_quest == null:
		update_quest_text.emit(null_quest)
		return
	update_quest_text.emit(active_quest.quest)

func is_questable(new_activity: QuestActivityInfo): 
	if new_activity == null:
		printerr("Attempt to activate null quest")
		return false
	var quest = new_activity.quest
	if quest == null: 
		printerr("Activity has null quest")
		return false
	if quest.question_generator == null: 
		printerr("Quest: " + quest.quest_title + " has no question generator")
		return false
	if not new_activity.is_possible: 
		return false
	return true

func deactivate_all_quests(): 
	for quest in quest_activities: 
		quest.is_active = false
	active_quest = null_activity
	qna.switch_question_generator(non_question)
	emit_update_quest_text()
	
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

func _on_answer_correct() -> void:
	active_quest.progress += PROGRESS_BY_ANSWER
	if active_quest.progress >= REQUIRED_PROGRESS:
		active_quest.progress -= REQUIRED_PROGRESS
		_on_quest_completed()
	refresh_quest_display()
	
func _on_quest_completed() -> void:
	quest_display.quest_complete(active_quest)
	var item_mods : Dictionary[ItemData, int] = active_quest.quest.item_mods
	for item in item_mods:
		stock_control.modify_item(item, item_mods[item])

func _on_stock_control_stock_update(item: ItemData, new_qty: int) -> void:
	#recheck quests
	update_quest_possibility()
	refresh_quest_display()
	
func create_quest_save_data() -> QuestSaveData:
	var save_data = QuestSaveData.new()
	var progress_dict : Dictionary[StringName, int] = {}
	for activity in quest_activities: 
		progress_dict[activity.quest.quest_id] = activity.progress
	save_data.quests_progress = progress_dict
	save_data.active_quest_id = active_quest.quest.quest_id
	return save_data
	
func load_from_quest_save_data(save_data: QuestSaveData): 
	var all_quests_dict: Dictionary[StringName, QuestDetails] = construct_all_quests_dict()
	var saved_progress_dict: Dictionary[StringName, int] = save_data.quests_progress
	var new_quest_activities: Array[QuestActivityInfo] = []
	var active_quest_id: StringName = save_data.active_quest_id
	var quest_to_activate = null_activity
	
	for quest_id in saved_progress_dict: 
		var quest : QuestDetails = all_quests_dict[quest_id]
		if not saved_progress_dict.has(quest_id):
			printerr("Quest ID " + quest_id + " not recognized")
			continue
		var activity = QuestActivityInfo.new()
		activity.quest = quest
		activity.progress = saved_progress_dict[quest_id]
		new_quest_activities.append(activity)
		if active_quest_id == activity.quest.quest_id: 
			quest_to_activate = activity
	
	quest_activities = new_quest_activities
	deactivate_all_quests()
	update_quest_possibility()
	activate_quest(quest_to_activate)
	quest_display.clear_all_quests()
	quest_display.initialize_with_quest_activity(quest_activities)
	refresh_quest_display()

func construct_all_quests_dict() -> Dictionary[StringName, QuestDetails]:
	var all_quests_dict: Dictionary[StringName, QuestDetails] = {}
	var all_quest_filenames : PackedStringArray  = DirAccess.get_files_at(all_quest_details_path)
	for filename in all_quest_filenames: 
		var path = all_quest_details_path + filename
		var quest : QuestDetails = ResourceLoader.load(path)
		all_quests_dict[quest.quest_id] = quest
	return all_quests_dict	
	
	
	
	
