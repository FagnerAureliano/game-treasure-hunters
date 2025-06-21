extends Control

class_name  UIEquipments

var _attributes_increased: Dictionary = {
	"armor": {}, "weapon": {}, "offhand": {}, 
}

@export_category("Objects")
@export var _weapon_slot: Button
@export var _armor_slot: Button
@export var _consumable_slot: Button
@export var _offhand_slot: Button


func _ready() -> void:
	global.ui_equipments = self

func equip_item(_item: Dictionary) -> void:
	var _item_name: String = _item.keys()[0]
	var _item_data: Dictionary = _item[_item_name]
	
	var _target_slot: Button = _consumable_slot
	if _item_data.has("equipment_type_name"):
		var _equipment_type: String = _item_data["equipment_type_name"] 
		match _equipment_type:
			"armor":
				_target_slot = _armor_slot
				_attributes_increased["armor"] = _item_data["attributes"] 
			"weapon":
				_target_slot = _weapon_slot
				_attributes_increased["weapon"] = _item_data["attributes"] 
			"offhand":
				_target_slot = _offhand_slot 
				_attributes_increased["offhand"] = _item_data["attributes"] 
				
	_target_slot.get_node("SlotTexture/ItemTexture").texture = load(_item_data["path"])
	
	global.character.reset_bonus_attributes()
	global.character.increase_bonus_attributes(_attributes_increased) 
