extends Node
class_name StockControl

signal stock_update(item, new_qty)

@export var stock_display : StockDisplay #attach node that displays the inventory
@export var initial_inventory: Dictionary[ItemData, int] = {}

@export var all_items_path : String = ""


var inventory: Dictionary[ItemData, int] = {}

func _ready():
	#var all_items_dict = construct_all_items_dict() 
	#print("ALL ITEMS")
	#for name in all_items_dict: 
		#print("Item " + name + ": " + str(all_items_dict[name]))
	
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

func has_required_resources(required_resources: Dictionary[StringName, int]) -> bool:
	for req_id in required_resources: 
		var inventory_knows_item = false
		for item in inventory: 
			if item.id != req_id: 
				continue
			inventory_knows_item = true
			if inventory[item] < required_resources[req_id]:
				return false
		if not inventory_knows_item:
			return false
	return true
		
func get_qty_for(item): 
	return inventory.get(item, 0)

func create_stock_save_data() -> StockSaveData:
	var save_data = StockSaveData.new()
	var qty_dict : Dictionary[StringName, int] = {}
	for item in inventory: 
		qty_dict[item.id] = inventory[item]
	save_data.stock_quantities = qty_dict
	return save_data
	
func load_from_stock_save_data(save_data: StockSaveData): 
	var all_items_dict: Dictionary[StringName, ItemData] = construct_all_items_dict()
	var saved_qty_dict: Dictionary[StringName, int] = save_data.stock_quantities
	var new_inventory: Dictionary[ItemData, int] = {}

	for item_id in saved_qty_dict: 
		if not all_items_dict.has(item_id): 
			printerr("Item " + item_id + " not recognized")
			continue
		var item : ItemData = all_items_dict[item_id]
		if saved_qty_dict.has(item_id):
			new_inventory[item] = saved_qty_dict[item_id]
	
	inventory = new_inventory
	stock_display.initialize_with_items(inventory.duplicate(false))

func construct_all_items_dict() -> Dictionary[StringName, ItemData]:
	var all_items_dict: Dictionary[StringName, ItemData] = {}
	var all_item_filenames : PackedStringArray  = DirAccess.get_files_at(all_items_path)
	for filename in all_item_filenames: 
		var path = all_items_path + filename
		var item : ItemData = ResourceLoader.load(path)
		all_items_dict[item.id] = item
	return all_items_dict
	
