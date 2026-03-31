extends HBoxContainer

var item

func setup(item_data: ItemData, qty):
	item = item_data
	$Icon.texture = item.icon
	update_quantity(qty)

func update_quantity(qty: int):
	$Qty.text = str(qty)
