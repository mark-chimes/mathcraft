extends HBoxContainer

var item
var current_effects : Array[Node2D] = []

func setup(item_data: ItemData, qty):
	item = item_data
	$Icon.texture = item.icon
	update_quantity(qty)

func update_quantity(qty: int):
	$Qty.text = str(qty)

func spawn_effect(effect_node: Node2D): 
	# We do this whole rigmarole so that we can spawn effects on top of one 
	# another and still have the top effect be visible. Because the effects
	# free themselves when they've faded out, we have to check if they are 
	# still valid
	var new_effects_array: Array[Node2D] = []
	for effect in current_effects:
		if is_instance_valid(effect):
			effect.fade_faster()
			new_effects_array.append(effect)
	effect_node.position.x += randf_range(-10, 10)
	effect_node.position.y = 30 + randf_range(-10, 10)
	add_child(effect_node)
	new_effects_array.append(effect_node)
	current_effects = new_effects_array
