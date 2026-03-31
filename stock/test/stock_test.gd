extends Node2D

signal add_items(item_data, qty)

@export var berry: ItemData
@export var stone: ItemData

func _on_more_berries_button_pressed() -> void:
	print("More berries button pressed")
	add_items.emit(berry, 3)


func _on_less_berries_button_pressed() -> void:
	print("less berries button pressed")
	add_items.emit(berry, -1)

func _on_more_stones_button_pressed() -> void:
	print("More stones button pressed")
	add_items.emit(stone, 3)

func _on_less_stones_button_pressed() -> void:
	print("less stones button pressed")
	add_items.emit(stone, -1)
