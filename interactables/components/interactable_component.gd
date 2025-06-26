extends Area2D

class_name InteractableComponent

@export_category("Variables")
@export var _is_static: bool = true
@export var _is_interactable: bool = true

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
	print(_area)
