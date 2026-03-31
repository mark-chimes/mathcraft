extends Node2D

@export var all_items: Array[ItemData] = []

func _ready():
	$StockDisplay._initial_display(all_items)
