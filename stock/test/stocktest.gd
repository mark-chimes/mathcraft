extends Node2D

@export var all_items: Array[ItemData] = []

func _ready():
	$StockDisplay.items = all_items
	# optionally call update if you want
	if $StockDisplay.has_method("_update_display"):
		$StockDisplay._update_display()
