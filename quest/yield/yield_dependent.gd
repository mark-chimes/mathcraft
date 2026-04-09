extends YieldSpecifier
class_name YieldDependent

# Yields a quantity dependent on the quantity of another resource

@export var yielded_item : ItemData
@export var based_on_resource: ItemData
@export var times_by: int

func stock_modifications(stock_control: StockControl) -> Dictionary[ItemData, int]: 
	var modifications_dict : Dictionary[ItemData, int] = {}
	var qty_based_on = stock_control.get_qty_for(based_on_resource)
	if qty_based_on <= 0: 
		return modifications_dict
	modifications_dict[yielded_item] = qty_based_on * times_by
	return modifications_dict

func description() -> String: 
	return yielded_item.display_name + ": +(" + based_on_resource.display_name + " x" + str(times_by) + ")"
	
