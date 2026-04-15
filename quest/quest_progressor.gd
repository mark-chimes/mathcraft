extends Node
class_name QuestProgressor

# QuestManager owns QuestProgressor
# The manager passes in activities 
# The progressor sends signals back up to the manager

signal quest_complete(activity)

const PRESSURE_PER_ANSWER = 2000
const MAX_PRESSURE = 10000
const MAX_ADDED_PROGRESS = 1000
	
const REQUIRED_PROGRESS = 1000

const PRESSURE_USE_DIVIDER = 50
const PRESSURE_LEAK_DIVIDER = 1

func on_correct_answer(activity) -> void:
	increase_pressure(activity, PRESSURE_PER_ANSWER)

func increase_pressure(activity, pressure_increase) -> void: 
	activity.pressure = clamp(activity.pressure+pressure_increase, 0, MAX_PRESSURE)
	increase_progress(activity, pressure_increase/10)

func process_activity(activity: ActivityInfo, delta) -> void: 
	if not activity.has_resources: 
		if activity.pressure >= 0:
			activity.pressure -= activity.pressure * delta / PRESSURE_LEAK_DIVIDER
			#activity.pressure = max(activity.pressure, 0.0)
		return 
		
	var pressure = activity.pressure
	if pressure > 0.0: 
		#var progress_increase = pressure * delta
		#pressure -= pressure * PRESSURE_DECAY * delta
		var per_second_increase = (pressure / PRESSURE_USE_DIVIDER) 
		per_second_increase = clamp(per_second_increase, 0, pressure)

		var progress_increase = per_second_increase * delta 
		progress_increase = clamp(progress_increase, 0, pressure)
		
		var pressure_decrease = progress_increase
		pressure -= pressure_decrease
		
		activity.pressure = pressure

		increase_progress(activity, progress_increase)
	
func increase_progress(activity, qty): 
	#progress_accumulated += qty
	activity.progress += qty
	while activity.progress >= REQUIRED_PROGRESS:
		activity.progress -= REQUIRED_PROGRESS
		quest_completed(activity)

func quest_completed(activity): 
	quest_complete.emit(activity)
