extends Node2D

signal got_stone(quantity)

var prog = 0
var req_prog = 1000
@onready var LevelUpDisp = preload("res://levelupdisp.tscn")

func _ready(): 
	update_xp_display()
	$ResIconLoc/ResDisp.queue_free()

func add_progress(prog_to_add): 
	prog += prog_to_add
	if prog >= req_prog: 
		get_resource()
	update_xp_display()

func update_xp_display(): 
	$CurrentLabel.text = str(prog) + " progress"
	$TargetLabel.text = "/ " + str(req_prog)
	$ProgressBar.value = 1.0 * prog / req_prog
	
func get_resource(): 
	var levelupdisp = LevelUpDisp.instantiate()
	var icon = load("res://assets/stone-pile.png")
	levelupdisp.set_icon_text_col(icon, "+1 stone", Color(0.5, 1.0, 0.5))
	$ResIconLoc.add_child(levelupdisp)
	
	prog -= req_prog
	if prog >= req_prog: 
		get_resource()
	got_stone.emit(1)
