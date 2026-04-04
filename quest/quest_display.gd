extends Control
class_name QuestDisplay

signal quest_activated(activity:QuestActivityInfo)

@export var quest_name_label : Label
@export var progress_bar : ProgressBar
@export var progress_text : Label
@export var active_button : CheckButton

const MAX_PROGRESS = 1000.0

var quest_activity : QuestActivityInfo # since we're using these as keys in dictionaries...

func bind_quest_activity(new_quest_activity: QuestActivityInfo): 
	quest_activity = new_quest_activity
	refresh()

# presses the button to deactivate the quest
func press_deactivate_button(): 
	active_button.set_pressed(false)

func _on_select_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		quest_activated.emit(quest_activity)
		
func refresh(): 
	# space added to text because of Godot bug 
	# https://github.com/godotengine/godot/issues/80499
	# https://github.com/godotengine/godot/issues/78523
	quest_name_label.text = " "+quest_activity.quest.quest_title 
	progress_bar.value = quest_activity.progress / 1000.0
	progress_text.text = " " + str(quest_activity.progress/MAX_PROGRESS) + " progress"
	active_button.button_pressed = quest_activity.is_active
