extends Node
#class_name QuestProgressor

signal quest_complete(activity)

@export var quest_display: QuestGroupDisplay
var activity : ActivityInfo
var is_initialized = false

	
var time_since_start = 0 
var progress_acc : float = 0.0

const MAX_PROGRESS = 5000
const PROGRESS_PER_ANSWER = 200

func on_correct_answer() -> void:
	allow_progress(PROGRESS_PER_ANSWER)
	
var progress_to_accumulate = 0
var progress_accumulated = 0

var PROGRESS_DECREASE_RATE = -1.0	#m
var SECONDS_TO_EMPTY = 0 # w
# w = sqrt(-2P/m)
var MAX_PROGRESS_RATE = 0 # h = -mw
var leftover_progress = 0.0

func _ready() -> void: 
	if activity != null: 
		print(" Progressor for activity " + str(activity.quest_title) + " ready!")
	else: 
		print(" Progressor ready, activity null")
	
func initialize(new_activity: ActivityInfo, new_quest_display: QuestGroupDisplay): 
	print("progressor initialized with activity " + str(new_activity.quest_title))
	print("progressor initialized with quest display " + str(new_quest_display))

	activity = new_activity
	quest_display = new_quest_display
	if not quest_display.is_node_ready():
		await quest_display.ready
	is_initialized = true

func apply_pressure(): 
	allow_progress(activity.pressure)

func _process(delta) -> void: 
	if not is_initialized: 
		return
	apply_progress(delta)

func allow_progress(progress_to_increase):
	leftover_progress = progress_to_accumulate - progress_accumulated
	progress_to_accumulate = clamp(progress_to_increase + leftover_progress, 0, MAX_PROGRESS)
	activity.pressure = progress_to_accumulate
	print("progress_to_accumulate: " + str(progress_to_accumulate))
	SECONDS_TO_EMPTY = sqrt(-(2.0*progress_to_accumulate) / PROGRESS_DECREASE_RATE) # w
	# w = sqrt(-2P/m)
	MAX_PROGRESS_RATE = -PROGRESS_DECREASE_RATE * SECONDS_TO_EMPTY # h = -mw
	time_since_start = 0.0
	progress_accumulated = 0
	activity.progress += progress_to_increase/5.0
	
func apply_progress(delta): 
	var midpoint = time_since_start + delta/2.0
	var progress = - PROGRESS_DECREASE_RATE * (SECONDS_TO_EMPTY - midpoint) * delta
	if progress <= 0.0:
		progress = 0.0
		return
	
	var progress_int : int = int(progress)
	progress_acc += (progress - progress_int)
	progress_int += int(progress_acc)
	progress_acc -= int(progress_acc)*1.0
	
	increase_progress(progress_int)
	
	var progress_per_second = progress / delta
	time_since_start += delta

const REQUIRED_PROGRESS = 1000
	
func increase_progress(qty): 
	progress_accumulated += qty
	var int_qty : int = int(qty)

	activity.progress += int_qty
	if activity.progress >= REQUIRED_PROGRESS:
		activity.progress -= REQUIRED_PROGRESS
		_quest_completed()
	leftover_progress = progress_to_accumulate - progress_accumulated
	activity.pressure = leftover_progress
	quest_display.refresh_display_for_quest(activity)

func _quest_completed(): 
	quest_complete.emit(activity)
