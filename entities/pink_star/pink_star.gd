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
			"type": "equipament",
			"value": 25,
			"spawn_probability": 0.05,  #5%
			"attributes":{
				"move_speed": 16,
				"defense": 1
			}
		},
	}


func _drop_item(_item_name: String, _item_data: Dictionary) -> void:
	print("Nome do item: "+ _item_name)
	print("Dados do item: "+ str(_item_data))
