extends Panel
class_name QuestGroupDisplay

signal quest_activated(quest_activity:QuestActivityInfo) # do not fire this signal manually

@export var QuestDisplayScene : PackedScene #:= preload("res://quest/quest_display.tscn")
@export var quests_container_node : Control


var activity_displays: Dictionary[QuestActivityInfo, QuestDisplay] = {}

func _ready(): 
	for child in quests_container_node.get_children():
		child.queue_free()

func initialize_with_quest_activity(initial_quests : Array[QuestActivityInfo]): 
	for quest_activity in initial_quests: 
		_add_quest(quest_activity)

# Don't call this unless you know the quest doesn't exist
# It's recommended to use update_quest instead
func _add_quest(quest_activity: QuestActivityInfo): 
	var new_quest_display := QuestDisplayScene.instantiate()
	quests_container_node.add_child(new_quest_display)
	activity_displays[quest_activity] = new_quest_display
	new_quest_display.bind_quest_activity(quest_activity)
	new_quest_display.quest_activated.connect(_on_quest_activated)

# Only works if the quest already exists
func refresh_display_for_quest(quest_activity: QuestActivityInfo): 
	var quest_display = activity_displays[quest_activity]
	quest_display.refresh()

func update_quest(quest_activity: QuestActivityInfo):
	if activity_displays.has(quest_activity): 
		refresh_display_for_quest(quest_activity)
	else:
		_add_quest(quest_activity)

# It's recommended you first activate a different quest...
func remove_quest(quest_activity: QuestActivityInfo): 
	var quest_display = activity_displays[quest_activity]
	var had_key = activity_displays.erase(quest_activity)
	if not had_key:
		printerr("No quest activity found")
		return
	quest_display.press_deactivate_button()
	quest_display.queue_free()

func activate_quest(quest_activity): 
	if not activity_displays.has(quest_activity): 
		printerr("No quest " + quest_activity.quest.quest_title + " recognized")
	var display = activity_displays[quest_activity]
	# note this causes the button to fire a signal to activate itself
	# don't fire the signal manually!
	display.active_button.set_pressed(true) 

# this is the only function that should fire the quest_activated signal
func _on_quest_activated(quest_activity:QuestActivityInfo): 
	quest_activated.emit(quest_activity)
