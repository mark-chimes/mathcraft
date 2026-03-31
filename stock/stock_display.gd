extends Control

@export var item_display_scene: PackedScene

@onready var container = $StockContainer

var displays := {} # Dictionary<ItemData, Node>

func display_inventory(items: Array[ItemData]):
	for item in items:
		var display = item_display_scene.instantiate()
		display.setup(item)
		container.add_child(display)
		displays[item] = display
