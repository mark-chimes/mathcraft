@tool
extends Control

@export var item_display_scene: PackedScene
@export var items: Array[ItemData] = []

@onready var container = $StockContainer

var displays := {} # Dictionary<ItemData, Node>

func _enter_tree():
	if Engine.is_editor_hint():
		_update_display()

func _update_display():
	for child in container.get_children():
		child.queue_free()
	displays.clear()

	for item in items:
		if item_display_scene:
			var display = item_display_scene.instantiate()
			display.setup(item)
			container.add_child(display)
			displays[item] = display

	#if Engine.is_editor_hint():
		#container.queue_sort()   # updates container layout
		#container.update()       # redraws Control nodes
