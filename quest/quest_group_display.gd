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

func refresh():
	for display in activity_displays.values(): 
		display.refresh()

# Does nothing if quest doesn't exist
func refresh_display_for_quest(quest_activity: QuestActivityInfo): 
	var quest_display = activity_displays[quest_activity]
	quest_display.refresh()

func update_quest(quest_activity: QuestActivityInfo):
	if activity_displays.has(quest_activity): 
		refresh_display_for_quest(quest_activity)
	else:
		_add_quest(quest_activity)

# Don't forget you might need to activate a different quest...
func remove_quest(quest_activity: QuestActivityInfo): 
	if not activity_displays.has(quest_activity):
		printerr("No display exists for activity: " + quest_activity.quest.quest_title)
		return
	var quest_display = activity_displays[quest_activity]
	activity_displays.erase(quest_activity)
	quest_display.queue_free()

func _on_quest_activated(quest_activity:QuestActivityInfo): 
	print("Quest group display got activation code for: " + quest_activity.quest.quest_title)
	quest_activated.emit(quest_activity)
