extends QuestDisplay

@export var pressure_bar : ProgressBar
@export var pressure_text: Label

const PRESSURE_DECAY = 50



func _ready(): 
	if not quest_name_label.is_node_ready():
		await quest_name_label.ready
	if not progress_text.is_node_ready():
		await progress_text.ready
	if not progress_bar.is_node_ready():
		await progress_bar.ready
	if not pressure_bar.is_node_ready():
		await pressure_bar.ready
	if not activate_button.is_node_ready():
		await activate_button.ready
		
func bind_quest_activity(new_quest_activity: ActivityInfo): 
	quest_activity = new_quest_activity
	refresh()
		
func refresh(): 
	# space added to text because of Godot bug 
	# https://github.com/godotengine/godot/issues/80499
	# https://github.com/godotengine/godot/issues/78523
	quest_name_label.text = " "+quest_activity.quest.quest_title 
	progress_bar.value = int(quest_activity.progress)
	pressure_bar.value = quest_activity.pressure
	progress_text.text = " " + str(int(quest_activity.progress)) + " progress"
	pressure_text.text = " " + str(int(quest_activity.pressure / 50.0)) + " /s"


	# Don't get confused between Godot's "disabled" and the quest's "is_active" 
	# This button should be clickable iff the quest is not active so it can be
	var is_focused = quest_activity.is_focused
	var has_resources = quest_activity.has_resources
	activate_button.set_disabled(is_focused)
	if is_focused and has_resources:
			activate_button.text = "active"
	elif not has_resources:
		activate_button.text = "impossible"
	else: 
		activate_button.text = ""
		
func _on_activate_button_pressed() -> void:
	if not quest_activity.is_focused:
		quest_activated.emit(quest_activity)
		
func set_to_big_size() -> void: 
	quest_name_label.add_theme_font_size_override("font_size", 24)
	progress_text.add_theme_font_size_override("font_size", 16)
	activate_button.add_theme_font_size_override("font_size", 16)
	pressure_bar.custom_minimum_size.y = 42
	custom_minimum_size.y = 80
	
func set_to_small_size() -> void: 
	quest_name_label.add_theme_font_size_override("font_size", 12)
	progress_text.add_theme_font_size_override("font_size", 8)
	activate_button.add_theme_font_size_override("font_size", 8)
	pressure_bar.custom_minimum_size.y = 21
	custom_minimum_size.y = 40
