extends Node 

class_name CharacterInventory

const _INVENTORY_SIZE: int = 18
var _inventory_data: Dictionary = {}

func _ready() -> void:
	global.inventory = self
	for _i in _INVENTORY_SIZE:
		_inventory_data[_i] = {}
	
func add_item(_item:Dictionary) -> void:
	for _slot in _inventory_data:
		if _inventory_data[_slot].is_empty():
			continue
		
		var _slot_keys: Array = _inventory_data[_slot].keys()
		var _slot_item_name: String = _slot_keys[0]
		if _slot_keys[0] == _item.keys()[0]:
			if _item[_item.keys()[0]]["type"] != "equipment":
				_inventory_data[_slot][_slot_item_name]["amount"] += 1
				
				global.ui_inventory.update_slot(_slot,_inventory_data[_slot][_slot_item_name])
				
				return


	for _slot in _inventory_data:
		if _inventory_data[_slot] == {}:
			_inventory_data[_slot] = _item
			var _slot_keys: Array = _inventory_data[_slot].keys()
			var _slot_item_name: String  = _slot_keys[0]
			_inventory_data[_slot][_slot_item_name]["amount"] = 1
			
			global.ui_inventory.update_slot(_slot,_inventory_data[_slot][_slot_item_name])
			
			break

func equip_item(_slot_index: int)-> void:
	_inventory_data[_slot_index] = {}
	global.ui_inventory.update_slot(_slot_index, {})
