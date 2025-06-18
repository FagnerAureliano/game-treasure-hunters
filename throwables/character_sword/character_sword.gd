extends ThrowableComponent

class_name CharacterSword

var direction: Vector2

@export_category("Variables")
@export var _move_speed: float  = 128.0

func _on_body_entered(_body: Node2D) -> void:
	if _body is TileMap:
		queue_free() 
		
func _physics_process(_delta: float) -> void:
	translate(direction * _delta * _move_speed)
