extends Node2D

signal have_stone(yes)

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
