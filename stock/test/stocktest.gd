extends Node2D

@export var all_items: Array[ItemData]

func _ready():
	$StockDisplay.display_inventory(all_items)
