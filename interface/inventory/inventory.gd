extends Control

class_name UIInventory

const _INVENTORY_SIZE: int = 18
const _INVENTORY_SLOT: PackedScene = preload("res://interface/inventory/inventory_slot.tscn")

@export_category("Objects")
@export var _slots_container: GridContainer

func _ready() -> void:
	for _i in _INVENTORY_SIZE:
		var _inventory_slot: UUInventorySlot = _INVENTORY_SLOT.instantiate()
		_slots_container.add_child(_inventory_slot)
