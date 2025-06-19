extends BaseEnemy

class_name PinkStar


func _attack() -> void:
	if not is_instance_valid(_player_in_range):
		return
	if _player_in_range.is_player_alive():
		_enemy_texture.action_animate("attack_anticipation")
	
