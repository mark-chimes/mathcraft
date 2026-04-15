extends Node
class_name QuestManager
signal update_quest_text(quest_details: QuestDetails)

@export var quest_display : QuestGroupDisplay
@export var stock_control : StockControl
@export var qna : QnA
@export var quest_progresser: PackedScene

@export var non_question: QuestionGenerator
@export var null_quest: QuestDetails

@export var all_quest_details_path : String = ""
@export var is_unlock_all = true # CHEAT to unlock all quests immediately

var null_activity : ActivityInfo
var locked_quests: Array[QuestDetails]

var quest_activities: Array[ActivityInfo]
@onready var progressor : QuestProgressor = $QuestProgressor

var focused_quest: ActivityInfo

const PROGRESS_BY_ANSWER = 800
const REQUIRED_PROGRESS = 1000

func _ready():
	null_activity = ActivityInfo.new()
	null_activity.quest = null_quest
	null_activity.is_focused = false
	null_activity.has_resources = false
	
	locked_quests = load_all_quests_except_null()
	unlock_quests()
	
	var first_quest = quest_activities[0]
	first_quest.has_resources = true
	activate_quest(first_quest)
	
	if not stock_control.is_node_ready():
		await stock_control.ready
	update_quest_resource_lock()

	if not quest_display.is_node_ready():
		await quest_display.ready
	quest_display.initialize_with_quest_activity(quest_activities)
	refresh_quest_display()

	if not progressor.is_node_ready(): 
		await progressor.ready
	progressor.refresh_display_for_activity.connect(_on_quest_progressor_refresh)
	progressor.quest_complete.connect(_quest_completed)
	
func _on_quest_progressor_refresh(activity): 
	quest_display.refresh()
	
func _process(delta) -> void : 
	for activity in quest_activities: 
		progressor.process_activity(activity, delta)

func deinitialize(): 
	quest_display.clear_all_quests()
	quest_activities.clear()
	locked_quests.clear()
	focused_quest = null_activity
	
func load_all_quests_except_null() -> Array[QuestDetails]: 
	var all_quests: Array[QuestDetails] = []
	var all_quest_filenames : PackedStringArray  = DirAccess.get_files_at(all_quest_details_path)
	print("Loading all quests from path: " + all_quest_details_path)
	for filename in all_quest_filenames: 
		var path = all_quest_details_path + filename
		var quest : QuestDetails = ResourceLoader.load(path)
		if quest.quest_id == "null_quest": 
			continue
		all_quests.append(quest)
	return all_quests

func remove_existing_activities_from_unlockable_quests(): 
	var to_remove: Array[QuestDetails] = []
	for activity in quest_activities:
		for quest in locked_quests: 
			if  quest == activity.quest: 
				to_remove.append(quest)
	for quest in to_remove: 
		locked_quests.erase(quest)
		
	
func unlock_quests(): 
	var to_unlock : Array[QuestDetails] = []
	
	if is_unlock_all:
		to_unlock = locked_quests.duplicate()
	else: 
		for quest in locked_quests:
			if quest.unlock_requirements == null: 
				to_unlock.append(quest)
			elif quest.unlock_requirements.is_unlocked(stock_control, self):
				to_unlock.append(quest)
				
	for quest in to_unlock:
		print("Unlocking quest: " + quest.quest_title)
		var new_activity = add_activity_for_quest(quest)
		if new_activity != null:
			quest_display.update_quest(new_activity)
		locked_quests.erase(quest)


func delete_deletable_quests(): 
	var to_delete : Array[ActivityInfo] = []
	for activity in quest_activities:
		for item in activity.quest.delete_quest_item_requirements:
			if stock_control.get_qty_for(item) <= 0: 
				to_delete.append(activity)
	for activity in to_delete: 
		remove_quest(activity)

func are_quests_completed(query_quests: Array[StringName]) -> bool: 
	for query in query_quests: 
		var activities_contains_quest = false

		for activity in quest_activities: 
			if activity.quest.quest_id == query:
				activities_contains_quest = true
				if activity.completion_times <= 0: 
					return false
		if not activities_contains_quest: 
			return false
	return true

func add_activity_for_quest(quest: QuestDetails) -> ActivityInfo:
	if have_activity_with_quest(quest): 
		return null
	var activity = ActivityInfo.new()
	activity.is_focused = false
	activity.progress = 0
	activity.quest = quest
	quest_activities.append(activity)
	return activity 
	
func update_quest_resource_lock(): 
	for activity in quest_activities: 
		activity.has_resources = true
		var item_mods = activity.quest.item_mods
		for item in item_mods: 
			var required_qty = - item_mods[item] # note negative
			if required_qty > 0:
				var stock_qty = stock_control.get_qty_for(item)
				if stock_qty < required_qty: 
					activity.has_resources = false

	if not focused_quest.has_resources: 
		deactivate_all_quests()
	
func _on_quest_group_display_quest_activated(activated_quest: ActivityInfo) -> void:
	activate_quest(activated_quest)
	refresh_quest_display()

func quest_display_deplete_quest(activity): 
	quest_display.spawn_quest_depletion_effect(activity)
	
func refresh_quest_display(): 
	emit_update_quest_text()
	quest_display.refresh()

func refresh_quest_display_for_activity(activity: ActivityInfo): 
	quest_display.refresh_display_for_quest(activity)

func activate_quest(new_quest : ActivityInfo): 
	if not is_questable(new_quest): 
		return
	new_quest.is_focused = true
	focused_quest = new_quest
	if focused_quest.has_resources:
		qna.switch_question_generator(focused_quest.quest.question_generator)
	else: 
		qna.switch_question_generator(non_question)
	for quest in quest_activities: 
		if quest!= new_quest:
			quest.is_focused = false

func emit_update_quest_text(): 
	if focused_quest == null:
		update_quest_text.emit(null_quest)
		return
	update_quest_text.emit(focused_quest.quest)

func is_questable(new_activity: ActivityInfo): 
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
	return true

func deactivate_all_quests(): 
	for quest in quest_activities: 
		quest.is_focused = false
	focused_quest = null_activity
	qna.switch_question_generator(non_question)
	emit_update_quest_text()
	
func remove_quest(activity: ActivityInfo): 
	if not quest_activities.has(activity): 
		printerr("Quest not found")
		return
	
	quest_activities.erase(activity)
	quest_display.remove_quest(activity)
	
	if quest_activities.is_empty():
		deactivate_all_quests()
	else:
		var new_focused_quest = quest_activities[0]
		activate_quest(new_focused_quest)
	
	refresh_quest_display()

func _on_answer_correct() -> void:
	print("Answer correct for activity: " + focused_quest.quest_title + ": " + str(focused_quest))
	progressor.on_correct_answer(focused_quest)

func _quest_completed(completed_quest) -> void:
	quest_display.quest_complete(completed_quest)
	completed_quest.completion_times += 1

	var yield_specifiers = completed_quest.quest.yield_specifiers
	for specifier in yield_specifiers: 
		var yields : Dictionary[ItemData, int] = specifier.stock_modifications(stock_control)
		for yield_item in yields: 
			stock_control.modify_item(yield_item, yields[yield_item])
			
	var item_mods : Dictionary[ItemData, int] = completed_quest.quest.item_mods
	for item in item_mods:
		stock_control.modify_item(item, item_mods[item])
	
	unlock_quests()
	delete_deletable_quests()

func have_activity_with_quest(quest)  -> bool: 
	print("Already have activity for quest: " + quest.quest_title)
	for activity in quest_activities: 
		if activity.quest == quest:
			return true
	return false

func _on_stock_control_stock_update(item: ItemData, new_qty: int) -> void:
	#recheck quests
	update_quest_resource_lock()
	refresh_quest_display()
	
func create_quest_save_data() -> QuestSaveData:
	var save_data = QuestSaveData.new()
	var progress_dict : Dictionary[StringName, int] = {}
	var completions_dict : Dictionary[StringName, int] = {}
	var pressure_dict : Dictionary[StringName, int] = {}

	for activity in quest_activities: 
		var id = activity.quest.quest_id
		progress_dict[id] = activity.progress
		completions_dict[id] = activity.completion_times
		pressure_dict[id] = activity.pressure
	save_data.quests_progress = progress_dict
	save_data.quests_completion_number = completions_dict
	save_data.quests_pressure = pressure_dict
	save_data.focused_quest_id = focused_quest.quest.quest_id
	return save_data
	
func load_from_quest_save_data(save_data: QuestSaveData): 
	deinitialize()
	var all_quests_dict: Dictionary[StringName, QuestDetails] = construct_all_quests_dict()
	var saved_progress_dict: Dictionary[StringName, int] = save_data.quests_progress
	var completion_qty_dict: Dictionary[StringName, int] = save_data.quests_completion_number
	var pressure_dict: Dictionary[StringName, int] = save_data.quests_pressure

	var new_quest_activities: Array[ActivityInfo] = []
	var focused_quest_id: StringName = save_data.focused_quest_id
	var quest_to_activate = null_activity
	
	for quest_id in saved_progress_dict: 
		var quest : QuestDetails = all_quests_dict[quest_id]
		if not saved_progress_dict.has(quest_id):
			printerr("Quest ID " + quest_id + " not recognized")
			continue
		var activity = ActivityInfo.new()
		activity.quest = quest
		activity.progress = saved_progress_dict[quest_id]
		activity.pressure = pressure_dict[quest_id]
		activity.completion_times = completion_qty_dict.get(quest_id, 0)
		new_quest_activities.append(activity)
		if focused_quest_id == activity.quest.quest_id: 
			quest_to_activate = activity
	
	quest_activities = new_quest_activities

	locked_quests = load_all_quests_except_null()
	remove_existing_activities_from_unlockable_quests()
	deactivate_all_quests()
	update_quest_resource_lock()
	unlock_quests()
	activate_quest(quest_to_activate)
	quest_display.initialize_with_quest_activity(quest_activities)
	delete_deletable_quests()
	refresh_quest_display()

func construct_all_quests_dict() -> Dictionary[StringName, QuestDetails]:
	var all_quests_dict: Dictionary[StringName, QuestDetails] = {}
	var all_quest_filenames : PackedStringArray  = DirAccess.get_files_at(all_quest_details_path)
	for filename in all_quest_filenames: 
		var path = all_quest_details_path + filename
		var quest : QuestDetails = ResourceLoader.load(path)
		all_quests_dict[quest.quest_id] = quest
	return all_quests_dict	
	
	
	
	
