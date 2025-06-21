extends BaseEnemy

class_name PinkStar


func _attack() -> void:
	if not is_instance_valid(_player_in_range):
		return
	if _player_in_range.is_player_alive():
		_enemy_texture.action_animate("attack_anticipation")
	
func _get_drop_items() -> Dictionary:
	return {
		"pink_star_head": {
			"path": "res://collectables_by_drop/pink_star/pink_star/pink_star_head.png",
			"type": "resource",
			"value": 5,
			"spawn_probability": 0.15  #15%
		},
		"pink_star_mouth": {
			"path": "res://collectables_by_drop/pink_star/pink_star/pink_star_mouth.png",
			"type": "resource",
			"value": 1,
			"spawn_probability": 0.75  #75%
		},
		"pink_star_legs": {
			"path": "res://collectables_by_drop/pink_star/pink_star/pink_star_legs.png",
			"type": "equipment",
			"value": 25,
			"spawn_probability": 1.0,  #5%
			"attributes":{
				"move_speed": 16,
				"defense": 1
			}, 
			"equipment_type_name": "armor"
		},
	}


func _drop_item(_item_name: String, _item_data: Dictionary) -> void:
	var _collectable: CollectableItem = _COLLECTABLE_ITEM.instantiate()
	_collectable.item_texture = _item_data["path"]
	_collectable.item_data = {
		_item_name: _item_data
	}
	_collectable.global_position = global_position
	get_tree().root.call_deferred("add_child", _collectable)
