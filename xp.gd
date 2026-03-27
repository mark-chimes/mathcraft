extends Node2D

var lvl = 1
var xp = 100
var next_level_xp = 1000
@onready var LevelUpDisp = preload("res://levelupdisp.tscn")

func add_xp(xp_to_add): 
	xp += xp_to_add
	if xp >= next_level_xp: 
		level_up()
	update_xp_display()

func update_xp_display(): 
	$LevelLabel.text = "lvl " + str(lvl)
	$CurrentLabel.text = str(xp) + " xp"
	$TargetLabel.text = "/ " + str(next_level_xp)
	$ProgressBar.value = 1.0 * xp / next_level_xp
	
func level_up(): 
	var levelupdisp = LevelUpDisp.instantiate()
	$LevelUpLoc.add_child(levelupdisp)
	
	xp -= next_level_xp
	lvl += 1
	if xp >= next_level_xp: 
		level_up()
