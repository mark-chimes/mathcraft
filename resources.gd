extends Node2D

signal have_stone(yes)
signal have_berries(yes)

var berry_qty = 0
var juice_qty = 0
var stone_qty = 0
var tool_qty = 0

func get_stone(quantity): 
	print("Got stone: " + str(quantity))
	stone_qty += quantity 
	$Stone/QtyLabel.text = str(stone_qty)
	have_stone.emit(stone_qty > 0)

func get_tools(quantity): 
	print("Got tools: " + str(quantity))

	tool_qty += quantity 
	$Axe/QtyLabel.text = str(tool_qty)

func got_berry(quantity: Variant) -> void:
	print("Got berries: " + str(quantity))
	berry_qty += quantity 
	$Berry/QtyLabel.text = str(berry_qty)
	have_berries.emit(berry_qty > 1) #TODO find a better way of doing this

func get_juice(quantity: Variant) -> void:
	print("Got juice: " + str(quantity))
	juice_qty += quantity 
	$Juice/QtyLabel.text = str(juice_qty)
