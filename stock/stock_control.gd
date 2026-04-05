extends Node
class_name StockControl

@export var stock_display : Control #attach node that displays the inventory
@export var initial_inventory: Dictionary[ItemData, int] = {}

signal stock_update(item, new_qty)

var inventory: Dictionary[ItemData, int] = {}

func _ready():
	inventory = initial_inventory.duplicate(false)
	stock_display.initialize_with_items(inventory.duplicate(false))

func modify_item(item: ItemData, qty: int): 
	var new_qty = inventory.get(item, 0) + qty
	if new_qty < 0: 
		printerr("New inventory value for: " + str(item.id) + " is " + str(new_qty) + " < 0")
		new_qty = 0
	inventory[item] = new_qty

	stock_display.update_item_qty(item, new_qty)
	stock_display.spawn_item_effect(item, qty)
	
	stock_update.emit(item, new_qty)

func get_qty_for(item): 
	return inventory.get(item, 0)
