extends Node2D

signal disable_craft

var is_craft_task_active = false
var is_juice_task_active = false

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
	
func _on_resources_have_berries(yes: Variant) -> void:
	pass
	if is_juice_task_active == yes:
		return
	is_juice_task_active = yes
	var locklabel = null
	if yes:
		$JuiceTask.modulate.a = 1.0
		$JuiceTask/JuiceButton.disabled = false
		locklabel = UnlockLabel.instantiate()
	else:
		$JuiceTask.modulate.a = 0.5
		$JuiceTask/JuiceButton.disabled = true
		$BerryTask/BerryButton.button_pressed = true
		locklabel = DepletionLabel.instantiate()
		locklabel.text = "Berries depleted"
		var active_label = ActiveLabel.instantiate()
		$AutoswitchBerryLoc.add_child(active_label)
	$JuiceLockLoc.add_child(locklabel)


func _on_stock_control_stock_update(item: Variant, new_qty: Variant) -> void:
	if item.id == "stone":
		_on_resources_have_stone(new_qty > 0)
	elif item.id == "thaumberry": 
		_on_resources_have_berries(new_qty > 1)
