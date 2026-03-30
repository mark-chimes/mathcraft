extends Node2D

signal disable_craft

var is_craft_task_active = false
@onready var DepletionLabel = preload("res://depletion_label.tscn")
@onready var UnlockLabel = preload("res://unlock_label.tscn")
@onready var ActiveLabel = preload("res://switch_label.tscn")


func _on_resources_have_stone(yes: Variant) -> void:
	if is_craft_task_active == yes:
		return
	is_craft_task_active = yes
	var locklabel = null
	if yes:
		$CraftTask.modulate.a = 1.0
		$CraftTask/CraftButton.disabled = false
		locklabel = UnlockLabel.instantiate()
	else:
		$CraftTask.modulate.a = 0.5
		$CraftTask/CraftButton.disabled = true
		$ScavengeTask/ScavengeButton.button_pressed = true
		locklabel = DepletionLabel.instantiate()
		var active_label = ActiveLabel.instantiate()
		$AutoswitchLoc.add_child(active_label)
	$CraftLockLoc.add_child(locklabel)
	
		
