extends Node2D

signal got_juice(quantity)
signal got_berry(quantity) # remember to emit negative quantity

signal got_item(item, quantity)

var prog = 0
var req_prog = 1000

@export var item_mods : Dictionary[ItemData, int] = {}

func _ready(): 
	update_xp_display()
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
	for item in item_mods: 
		got_item.emit(item, item_mods[item])
	
	prog -= req_prog
	if prog >= req_prog: 
		get_resource()
	got_berry.emit(-2)
	got_juice.emit(1)
