extends Node2D

signal got_tools(quantity)
signal got_stone(quantity) # remember to emit negative quantity

var prog = 0
var req_prog = 1000
@onready var LevelUpDisp = preload("res://levelupdisp.tscn")

func _ready(): 
	update_xp_display()
	$ResIconLoc/ResDisp.queue_free()
	$UseIconLoc/ResDisp.queue_free()
	modulate.a = 0.5

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
	var gen_rec_disp = LevelUpDisp.instantiate()
	var gen_rec_icon = load("res://assets/stone-axe.png")
	gen_rec_disp.set_icon_text_col(gen_rec_icon, "+1 tool", Color(0.5, 1.0, 0.5))
	$ResIconLoc.add_child(gen_rec_disp)
	
	var use_res_disp = LevelUpDisp.instantiate()
	var use_icon = load("res://assets/stone-pile.png")
	use_res_disp.set_icon_text_col(use_icon, "-1 stone", Color(1.0, 0.3, 0.0))
	$UseIconLoc.add_child(use_res_disp)
	
	prog -= req_prog
	if prog >= req_prog: 
		get_resource()
	got_stone.emit(-1)
	got_tools.emit(1)
