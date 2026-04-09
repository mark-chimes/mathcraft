extends Panel
class_name QuestGroupDisplay

signal quest_activated(quest_activity:ActivityInfo) # do not fire this signal manually

@export var QuestDisplayScene : PackedScene
@export var quests_container_node : Control
@export var level_up_disp : PackedScene
@export var depletion_disp : PackedScene

@export var level_up_icon : Texture2D

var activity_displays: Dictionary[ActivityInfo, QuestDisplay] = {}

@export var is_big_size = true

func _ready(): 
	for child in quests_container_node.get_children():
		child.queue_free()

func clear_all_quests(): 
	for display in activity_displays.values(): 
		display.queue_free()
	activity_displays.clear()

func initialize_with_quest_activity(initial_quests : Array[ActivityInfo]): 
	for quest_activity in initial_quests: 
		_add_quest(quest_activity)

# Don't call this unless you know the quest's display doesn't exist
# It's recommended to use update_quest instead
func _add_quest(quest_activity: ActivityInfo): 
	var new_quest_display := QuestDisplayScene.instantiate()
	quests_container_node.add_child(new_quest_display)
	activity_displays[quest_activity] = new_quest_display
	new_quest_display.bind_quest_activity(quest_activity)
	new_quest_display.quest_activated.connect(_on_quest_activated)
	if is_big_size: 
		new_quest_display.set_to_big_size()
	else: 
		new_quest_display.set_to_small_size()

func refresh():
	for display in activity_displays.values(): 
		display.refresh()

# Does nothing if quest doesn't exist
func refresh_display_for_quest(quest_activity: ActivityInfo): 
	var quest_display = activity_displays[quest_activity]
	quest_display.refresh()

func update_quest(quest_activity: ActivityInfo):
	if quest_activity == null: 
		return
	if activity_displays.has(quest_activity): 
		refresh_display_for_quest(quest_activity)
	else:
		_add_quest(quest_activity)

# Don't forget you might need to activate a different quest...
func remove_quest(quest_activity: ActivityInfo): 
	if not activity_displays.has(quest_activity):
		printerr("No display exists for activity: " + quest_activity.quest.quest_title)
		return
	var quest_display = activity_displays[quest_activity]
	activity_displays.erase(quest_activity)
	quest_display.queue_free()

func _on_quest_activated(quest_activity:ActivityInfo): 
	quest_activated.emit(quest_activity)

func quest_complete(quest_activity:ActivityInfo): 
	spawn_quest_complete_effect(quest_activity)
	
func spawn_quest_complete_effect(quest_activity:ActivityInfo): 
	var activity_node = activity_displays[quest_activity]
	var level_up = level_up_disp.instantiate()
	quests_container_node.add_child(level_up)
	level_up.position = activity_node.position
	level_up.set_icon_text_col(level_up_icon, "quest complete!", Color(0,1.0,0.5,1))

func spawn_quest_depletion_effect(quest_activity: ActivityInfo):
	var activity_node = activity_displays[quest_activity]
	var depletion = depletion_disp.instantiate()
	quests_container_node.add_child(depletion)
	depletion.position = activity_node.position

func _on_bigger_text_button_pressed() -> void:
	is_big_size = true
	for display in activity_displays.values(): 
		display.set_to_big_size()
		
func _on_smaller_text_button_pressed() -> void:
	is_big_size = false
	for display in activity_displays.values(): 
		display.set_to_small_size()
