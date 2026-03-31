extends Control

@export var item_display_scene: PackedScene
@export var preview_items: Array[ItemData] = []

@onready var container = $StockContainer


#func _enter_tree():
	#if Engine.is_editor_hint():
		#_editor_display_preview()
		#return

## Only to be used in-editor
#func _editor_display_preview(): 
	#if item_display_scene == null: 
		#printerr("No Item Display Scene set")
#
	#for child in container.get_children():
		#child.queue_free()
	#
	#for item in preview_items: 
		#var display = item_display_scene.instantiate()
		#display.setup(item)
		#container.add_child(display)
		
var item_display_dict : Dictionary[ItemData, Node] = {} #Dict<ItemData, ItemDisplayScene>
var initial_items: Dictionary[ItemData, int] = {}

func _ready(): 
	if initial_items.size() > 0:
		_initial_display(initial_items)
		initial_items.clear()
		
func initialize_with_items(items: Dictionary[ItemData, int]):
	initial_items = items
	if is_inside_tree() and container != null:
		_initial_display(initial_items)
		initial_items.clear()

func update_item_qty(item, new_qty): 
	if item in item_display_dict:
		item_display_dict[item].update_quantity(new_qty)
	else: 
		create_item(item, new_qty)

func _initial_display(items_dict): 
	if not item_display_dict.is_empty(): 
		printerr("Dictionary has already been initialized")
		return 
	for item in items_dict:
		create_item(item, items_dict[item])

func create_item(item, qty): 
	if item.icon == null:
		printerr("Missing display or icon for item ", item)
		return
	var display = item_display_scene.instantiate()
	display.setup(item, qty)
	container.add_child(display)
	item_display_dict[item] = display
