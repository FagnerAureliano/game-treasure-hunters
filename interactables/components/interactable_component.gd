extends Area2D

class_name InteractableComponent

const _NON_COLECTABLE_ITEM: PackedScene = preload("res://collectables/components/collectable_item.tscn")

@export_category("Variables")
@export var _health: int = 10
@export var _is_static: bool = true
@export var _is_interactable: bool = true
@export var _interactable_pieces: Array[String]

@export_category("Objects")
@export var _sprite: AnimatedSprite2D
@export var _body_collision: CollisionShape2D

func _ready() -> void:
	_sprite.play("idle")
	if not _is_static:
		_body_collision.disabled = true

func _on_interactable_area_entered(_area: Area2D) -> void:
	if not _is_interactable:
		return
	if _area is CharacterAttackArea:
		_interact(_area)

func _interact(_area: Area2D) -> void:
	var _damage: int = _area.get_damage()
	_health -= _damage
	if _health <= 0:
		_destroy()
		return
		
	if _sprite.animation == "hit":
		_sprite.frame = 0
	_sprite.play("hit")

func _destroy() -> void:
	for _piece in _interactable_pieces:
		var _non_c_item: CollectableItem = _NON_COLECTABLE_ITEM.instantiate()
		_non_c_item.is_collectable = false
		_non_c_item.item_texture = _piece
		
		_non_c_item.global_position = global_position
		get_tree().root.call_deferred("add_child", _non_c_item)
		
	queue_free()


func _on_texture_animation_finished() -> void:
	if _sprite.animation == "hit":
		_sprite.play("idle")
