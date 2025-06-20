extends CanvasLayer

class_name HUD

@export_category("Objects")
@export var _ui_inventory: UIInventory

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("inventory"):
		_ui_inventory.visible = not _ui_inventory.visible
