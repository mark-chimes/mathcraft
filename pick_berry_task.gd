extends Node2D

signal got_berry(quantity)
signal got_item(item, quantity)

@export var item_mods : Dictionary[ItemData, int] = {}

var prog = 0
var req_prog = 1000
@onready var LevelUpDisp = preload("res://levelupdisp.tscn")

func _ready(): 
	update_xp_display()

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
	got_berry.emit(1)
