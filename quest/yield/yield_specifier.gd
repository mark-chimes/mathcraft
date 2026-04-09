extends Resource
class_name YieldSpecifier

# Abstract class for when there is some mathematical calculation for when items 
# are yielded

# Override this function
# Describes how what stock is yielded, dependent on the existing stock
func stock_modifications(stock_control: StockControl) -> Dictionary[ItemData, int]: 
	return {}

# Override this function
# A string describing how much resources the player can expect
func description() -> String: 
	return ""
