extends Area2D

class_name Water

const _WARER_SPLASH_EFFECTS: Array = [
	 "res://visual_effects/water_splash/1/water_splash_1.tscn",
	 "res://visual_effects/water_splash/2/water_splash_2.tscn"
]

var _objects_in_contact: Array

@export_category("Objects")
@export var _time_to_kill: Timer

func _on_body_entered(_body: Node2D) -> void:
	if not _body is TileMap:
		global.spawn_effect(
			_WARER_SPLASH_EFFECTS.pick_random(), Vector2.ZERO, 
			_body.global_position, false 
		)
	
	if _body is BaseCharacter: 
		_body.disable()

	if _body is BaseEnemy or( _body is CollectableItem and _body.is_collectable) :
		_objects_in_contact.append(_body)
		_time_to_kill.start()

func _on_time_to_kill_timeout() -> void:
	for _object in _objects_in_contact:
		if (
			_object is BaseEnemy or 
			_object is CollectableItem
		):
			_object.queue_free()
	_objects_in_contact = []
