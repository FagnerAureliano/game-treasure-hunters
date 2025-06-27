extends RigidBody2D

class_name CollectableItem

var is_collectable: bool = true

var item_data:Dictionary = {}
var item_texture: String

@export_category("Object")
@export var _item_sprite: Sprite2D
@export var _animation: AnimationPlayer

@export_category("Variables")
@export var _horizonal_force: float = 80
@export var _vertical_force: float = -300

func _ready() -> void:
	if not is_collectable:
		_animation.play("kill")
	_item_sprite.texture = load(item_texture)
	
	apply_impulse(
		Vector2(
			[_horizonal_force, -_horizonal_force].pick_random(),
			_vertical_force
		)
	)

func _on_collectable_area_body_entered(_body: Node2D) -> void:
	if not is_collectable:
		return
		
	if _body is BaseCharacter:
		_body.collect_item(item_data)
		global.spawn_effect(
			"res://visual_effects/coin_effect/base_effect.tscn", 
			Vector2.ZERO, global_position, false) 
		queue_free()
