extends HBoxContainer

var item

func setup(item_data: ItemData):
	item = item_data
	$Icon.texture = item.icon
	update_quantity(0)

func update_quantity(qty: int):
	$Qty.text = str(qty)
