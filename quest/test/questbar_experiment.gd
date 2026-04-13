extends Node2D

@export var quest_display: QuestGroupDisplay

@export var quest1: QuestDetails

var activity1 : ActivityInfo

const REQUIRED_PROGRESS = 1000

var current_progress_per_timeout : float = 0.0

var progress_timer : Timer
var times_progressed : int = 0
const PRESURE_PER_ANSWER : int = 100
const MAX_PRESSURE : int = 500
const MAX_PROGRESS_PER_TIMEOUT : int = 5
const REDUCTION_QTY : float = (1.0*MAX_PROGRESS_PER_TIMEOUT) / (1.0*PRESURE_PER_ANSWER)
const PROGRESS_TIMER_TIME = 5.0

func _ready() -> void: 
	print("REDUCTION_QTY: " + str(REDUCTION_QTY))
	activity1 =  ActivityInfo.new()
	activity1.quest = quest1
	activity1.is_possible = true
	activity1.is_active = true
	
	var activities: Array[ActivityInfo] = [activity1]
	
	if not quest_display.is_node_ready():
		await quest_display.ready
	quest_display.initialize_with_quest_activity(activities)
	quest_display.refresh()
	
func _on_qn_a_answer_correct() -> void:
	increase_progress(50)
	add_timer()
	
func increase_progress(qty): 
	var int_qty : int = int(qty)

	activity1.progress += int_qty
	if activity1.progress >= REQUIRED_PROGRESS:
		activity1.progress -= REQUIRED_PROGRESS
		_quest_completed()
	quest_display.refresh()

func _quest_completed(): 
	pass
	
func add_timer():
	times_progressed = clamp(times_progressed + PRESURE_PER_ANSWER, 0, MAX_PRESSURE)
	current_progress_per_timeout = MAX_PROGRESS_PER_TIMEOUT
	print("times_progressed: " + str(times_progressed))
	if progress_timer: 
		progress_timer.queue_free()
	progress_timer = Timer.new()
	add_child(progress_timer)
	
	var next_timer_wait_time = PROGRESS_TIMER_TIME / (times_progressed)
	progress_timer.wait_time = next_timer_wait_time
	progress_timer.one_shot = false
	progress_timer.start()
	progress_timer.timeout.connect(_on_progress_timer_timeout)
	
func _on_progress_timer_timeout() -> void: 
	increase_progress(current_progress_per_timeout)
	times_progressed -= 1
	if times_progressed <= 0: 
		progress_timer.queue_free()
	var next_timer_wait_time = PROGRESS_TIMER_TIME / (times_progressed)

	progress_timer.wait_time = next_timer_wait_time

		
#func add_timer():
	#times_progressed = MAX_TIMEOUT_TIMES
	#current_progress_per_timeout = MAX_PROGRESS_PER_TIMEOUT
	#if progress_timer: 
		#progress_timer.queue_free()
	#progress_timer = Timer.new()
	#add_child(progress_timer)
	#
	#progress_timer.wait_time = PROGRESS_TIMER_TIME
	#progress_timer.one_shot = false
	#progress_timer.start()
	#progress_timer.timeout.connect(_on_progress_timer_timeout)
	#
#func _on_progress_timer_timeout() -> void: 
	#increase_progress(current_progress_per_timeout)
	#current_progress_per_timeout =  current_progress_per_timeout - REDUCTION_QTY
	#times_progressed -= 1
	#if times_progressed <= 0: 
		#progress_timer.queue_free()
