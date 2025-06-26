extends Node2D

class_name BaseLevel

@export_category("Variables")
@export var _scene_path: String

func _ready() -> void:
	global.current_scene_path = _scene_path 

func load_level() -> void:
	transition_screen.fade_in()
	#get_tree().change_scene_to_file(_scene_path)
