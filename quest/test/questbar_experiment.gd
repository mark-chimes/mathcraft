extends Node2D

@export var quest_display: QuestGroupDisplay

@export var quest1: QuestDetails

var activity1 : ActivityInfo



func _ready() -> void: 
	activity1 =  ActivityInfo.new()
	activity1.quest = quest1
	activity1.is_possible = true
	activity1.is_active = true
	activity1.pressure = 0.0
	
	var activities: Array[ActivityInfo] = [activity1]
	
	if not quest_display.is_node_ready():
		await quest_display.ready
	quest_display.initialize_with_quest_activity(activities)
	quest_display.refresh()
	
	$Label/qty_per_second_label.text = str(MAX_PROGRESS_RATE)

var time_since_start = 0 
var progress_acc : float = 0.0

func _process(delta) -> void: 
	#var x_1 = time_since_start
	#var x_2 = time_since_start + delta
	#var ave = (x_1 + x_2) / 2
	apply_progress(delta)



const MAX_PROGRESS = 5000
const PROGRESS_PER_ANSWER = 200

func _on_qn_a_answer_correct() -> void:
	allow_progress(PROGRESS_PER_ANSWER)
	
var progress_to_accumulate = 0
var progress_accumulated = 0

var PROGRESS_DECREASE_RATE = -1.0	#m
var SECONDS_TO_EMPTY = 0 # w
# w = sqrt(-2P/m)
var MAX_PROGRESS_RATE = 0 # h = -mw
var leftover_progress = 0.0

func allow_progress(progress_to_increase):
	leftover_progress = progress_to_accumulate - progress_accumulated
	progress_to_accumulate = clamp(progress_to_increase + leftover_progress, 0, MAX_PROGRESS)
	activity1.pressure = progress_to_accumulate
	print("progress_to_accumulate: " + str(progress_to_accumulate))
	SECONDS_TO_EMPTY = sqrt(-(2.0*progress_to_accumulate) / PROGRESS_DECREASE_RATE) # w
	# w = sqrt(-2P/m)
	MAX_PROGRESS_RATE = -PROGRESS_DECREASE_RATE * SECONDS_TO_EMPTY # h = -mw
	time_since_start = 0.0
	progress_accumulated = 0
	activity1.progress += progress_to_increase/5.0
	$Label2/progress_to_acc_label.text = str(progress_to_accumulate)
	
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
	$Label/qty_per_second_label.text = str(int(progress_per_second))
	time_since_start += delta

const REQUIRED_PROGRESS = 1000
	
func increase_progress(qty): 
	progress_accumulated += qty
	$Label3/progress_accd_label.text = str(progress_accumulated)
	var int_qty : int = int(qty)

	activity1.progress += int_qty
	if activity1.progress >= REQUIRED_PROGRESS:
		activity1.progress -= REQUIRED_PROGRESS
		_quest_completed()
	leftover_progress = progress_to_accumulate - progress_accumulated
	activity1.pressure = leftover_progress
	quest_display.refresh()

func _quest_completed(): 
	pass
#
#var current_progress_per_timeout : float = 0.0
#
#var progress_timer : Timer
#var times_progressed : int = 0
#const PRESURE_PER_ANSWER : int = 100
#const MAX_PRESSURE : int = 500
#const MAX_PROGRESS_PER_TIMEOUT : int = 5
#const REDUCTION_QTY : float = (1.0*MAX_PROGRESS_PER_TIMEOUT) / (1.0*PRESURE_PER_ANSWER)
#const PROGRESS_TIMER_TIME = 5.0


#

	#

	
#func add_timer():
	#times_progressed = clamp(times_progressed + PRESURE_PER_ANSWER, 0, MAX_PRESSURE)
	#current_progress_per_timeout = MAX_PROGRESS_PER_TIMEOUT
	#print("times_progressed: " + str(times_progressed))
	#if progress_timer: 
		#progress_timer.queue_free()
	#progress_timer = Timer.new()
	#add_child(progress_timer)
	#
	#var next_timer_wait_time = PROGRESS_TIMER_TIME / (times_progressed)
	#progress_timer.wait_time = next_timer_wait_time
	#progress_timer.one_shot = false
	#progress_timer.start()
	#progress_timer.timeout.connect(_on_progress_timer_timeout)
	#
#func _on_progress_timer_timeout() -> void: 
	#increase_progress(current_progress_per_timeout)
	#times_progressed -= 1
	#if times_progressed <= 0: 
		#progress_timer.queue_free()
	#var next_timer_wait_time = PROGRESS_TIMER_TIME / (times_progressed)
#
	#progress_timer.wait_time = next_timer_wait_time

		
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
