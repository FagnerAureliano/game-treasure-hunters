extends Button

class_name UUInventorySlot

@export_category("Objects")
@export var _slot_label: Label
@export var _slot_texture: TextureRect

func update(_item_data: Dictionary) -> void:
	_slot_texture.texture = load(_item_data["path"])
	
	if _item_data["type"] != "equipament":
		_slot_label.text = str(_item_data["amount"])
