extends ParallaxBackground

class_name Background

const _Y_THRESHOLD: float = 244.0
const _HEIGHT: float = 360.0

@onready var _clouds: Array = [
	$CloudT1, $CloudT2, $CloudT3, $CloudT4, 
	$CloudT5, $CloudT6, $CloudT7, $CloudT8
]

var _speed_values: Array[float] = [
	16.0, 16.0, 4.0, 4.0, 
	8.0, 8.0, 12.0, 12.0
]

@export_category("Objects")
@export var _additional_water: ParallaxLayer
@export var _additional_sky: ParallaxLayer
@export var _character: BaseCharacter

func _physics_process(_delta: float) -> void:
	var _i: int = 0
	for cloud in _clouds:
		cloud.motion_offset.x -= _speed_values[_i] * _delta
		_i += 1
	#if _character.global_position.y > _Y_THRESHOLD:
		#_additional_water.motion_mirroring.y = _HEIGHT
		#_additional_sky.motion_mirroring.y = 0
		#
	#if _character.global_position.y < _Y_THRESHOLD:
		#_additional_water.motion_mirroring.y = 0
		#_additional_sky.motion_mirroring.y = _HEIGHT
	#
