extends Control

@export var quest_name_label : Label
@export var progress_bar : ProgressBar
@export var progress_text : Label
@export var active_button : CheckButton

const MAX_PROGRESS = 1000.0

func initialize_quest_details(quest_activity: QuestActivityInfo): 
	# space added to text because of Godot bug 
	# https://github.com/godotengine/godot/issues/80499
	# https://github.com/godotengine/godot/issues/78523
	quest_name_label.text = " "+quest_activity.quest.quest_title 
	progress_bar.value = quest_activity.progress
	progress_text.text = " " + str(quest_activity.progress/MAX_PROGRESS) + " progress"
	active_button.button_pressed = quest_activity.is_active
