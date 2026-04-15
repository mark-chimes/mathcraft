extends Node
class_name QuestProgressor

# TODO QuestManager owns QuestProgressor
# The manager passes in activities 
# The progressor sends signals back up to the manager

signal quest_complete(activity)
signal refresh_display_for_activity(activity)

const PRESSURE_PER_ANSWER = 100
const MAX_PRESSURE = 10000
	
func apply_pressure(): 
	#allow_progress(activity.pressure)
	pass # TODO
	
const PRESSURE_DECAY = 0.05
const REQUIRED_PROGRESS = 5000

func on_correct_answer(activity) -> void:
	increase_pressure(activity, PRESSURE_PER_ANSWER)

func increase_pressure(activity, pressure_increase) -> void: 
	activity.pressure = clamp(activity.pressure+pressure_increase, 0, MAX_PRESSURE)

func process_activity(activity, delta) -> void: 
	var pressure = activity.pressure
	if pressure > 0.0: 
		var progress_increase = pressure * delta
		pressure -= pressure * PRESSURE_DECAY * delta
		activity.pressure = pressure

		increase_progress(activity, progress_increase)
		refresh_display_for_activity.emit(activity)
	
func increase_progress(activity, qty): 
	#progress_accumulated += qty
	var int_qty : int = int(qty)

	activity.progress += int_qty
	while activity.progress >= REQUIRED_PROGRESS:
		activity.progress -= REQUIRED_PROGRESS
		quest_completed(activity)

func quest_completed(activity): 
	quest_complete.emit(activity)
