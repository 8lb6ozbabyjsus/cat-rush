extends Node

var inventory : Dictionary = {}

func add_item( type : String, value  : String ):
	inventory[type] = value
	print("Item added to inventory - Type: ", type, ", Value: ", value)
	print("Current inventory: ", inventory)
	
func has_item( value : String) -> bool:
	if value == null:
		return false

	var item = inventory.find_key(value)
	
	if item:
		return true
	return false
