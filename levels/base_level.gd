extends Node2D

class_name BaseLevel

@export_category("Variables")
@export var _scene_path: String

func _ready() -> void:
	global.current_scene_path = _scene_path 
