extends CanvasLayer

class_name TransitionScreen

var scene_path: String

@export_category("Objects")
@export var _animation: AnimationPlayer

func fade_in() -> void:
	scene_path = global.current_scene_path
	_animation.play("fade_in")
	pass


func _on_animation_finished(_anim_name: StringName) -> void:
	match _anim_name:
		"fade_in":
			get_tree().change_scene_to_file(scene_path)
			_animation.play("fade_out")
		"fade_out":
			pass
