extends Control

class_name  UIEquipments

var _attributes_increased: Dictionary = {
	"armor": {}, "weapon": {}, "offhand": {}, 
}
var _equipments_inventory: Dictionary = {
	"armor": {}, "weapon": {}, "offhand": {}, "consumable": {}, 
}

@export_category("Objects")
@export var _weapon_slot: Button
@export var _armor_slot: Button
@export var _consumable_slot: Button
@export var _offhand_slot: Button


func _ready() -> void:
	global.ui_equipments = self
	for _button in get_tree().get_nodes_in_group("equipment_slot"):
		_button.pressed.connect(_on_button_pressed.bind(_button))
		
func _on_button_pressed(_button_pressed:Button) -> void:
	var _item_slot: TextureRect = _button_pressed.get_node("SlotTexture/ItemTexture")
	_button_pressed.release_focus()
	if _item_slot.texture == null:
		print("slot vazio!")
		return
	
	var _equipment_slot_type: String = ""
	
	match _button_pressed.name:
		"ConsumableSlot":
			_equipment_slot_type = "consumable"
			pass
		"WeaponSlot":
			_attributes_increased["weapon"] = {}
			_equipment_slot_type = "weapon"
			pass
		"ArmorSlot":
			_attributes_increased["armor"] = {}
			_equipment_slot_type = "armor"
			pass
		"OffHandSlot":
			_attributes_increased["offhand"] = {}
			_equipment_slot_type = "offhand"
			pass

	var _item_data: Dictionary = _equipments_inventory[_equipment_slot_type]
	global.inventory.add_item(_item_data)
	_item_slot.texture = null
	global.character.reset_bonus_attributes()
	global.character.increase_bonus_attributes(_attributes_increased) 

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
			"consumable":
				_target_slot = _consumable_slot 

		_equipments_inventory[_equipment_type] = {
			_item_name: _item_data
		}
	_target_slot.get_node("SlotTexture/ItemTexture").texture = load(_item_data["path"])
	
	global.character.reset_bonus_attributes()
	global.character.increase_bonus_attributes(_attributes_increased) 
