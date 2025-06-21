extends Button

class_name UUInventorySlot

var _item:Dictionary = {}

@export_category("Objects")
@export var _slot_label: Label
@export var _slot_texture: TextureRect

func update(_item_data: Dictionary) -> void:
	_item = _item_data
	
	if _item_data.is_empty():
		_slot_texture.texture = null
		_slot_label.text = ""
		return
	
	_slot_texture.texture = load(_item_data["path"])
	
	if _item_data["type"] != "equipment":
		_slot_label.text = str(_item_data["amount"])


func _on_pressed() -> void:
	if _item.is_empty():
		return
	
	if _item["type"] == "equipment":
		print(_item)
		global.inventory.equip_item(get_index())
