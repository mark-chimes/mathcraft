extends HBoxContainer

var item
var current_effect : Node2D = null

func setup(item_data: ItemData, qty):
	item = item_data
	$Icon.texture = item.icon
	update_quantity(qty)

func update_quantity(qty: int):
	$Qty.text = str(qty)

func spawn_effect(effect_node: Node2D): 
	if current_effect != null: 
		current_effect.queue_free()
	effect_node.position.y = 30
	current_effect = effect_node
	add_child(effect_node)
