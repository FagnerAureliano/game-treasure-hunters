extends CharacterBody2D

class_name BaseCharacter

var _has_sword: bool = false
var _on_floor: bool = true
var _jump_count = 0
var _attack_index: int = 1
var _air_attack_count: int = 0

const _THROWABLE_SWORD: PackedScene = preload("res://throwables/character_sword/character_sword.tscn")

@export_category('Variables')
@export var _speed: float = 150.0
@export var _jump_velocity: float = -300.0
@export var _attack_combo: Timer
@export var _character_health: int = 10

@export_category("Objects")
@export var _character: CharacterTexture

func _physics_process(delta: float) -> void: 
	_vertical_movement(delta) 
	_horizontal_movement()  
	_attack_handler()
	
	move_and_slide()
	
	_character.animate(velocity)

func _vertical_movement(_delta: float) -> void:
	# Add the gravity.
	if is_on_floor():  
		if _on_floor == false:
			global.spawn_effect(
				"res://visual_effects/dust_particles/fall/fall_effect.tscn", 
				Vector2(0,2), global_position, false)
			_character.action_animaton("land")
			set_physics_process(false)
			_on_floor = true
		
		_jump_count = 0
		_air_attack_count = 0
	
	if not is_on_floor():
		if is_on_floor:
			_attack_index = 1
		
		_on_floor = false
		velocity += get_gravity() * _delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and _jump_count < 2:
		_jump_count += 1
		_attack_index = 1
		velocity.y = _jump_velocity
		global.spawn_effect(
			"res://visual_effects/dust_particles/jump/jump_effect.tscn", 
			Vector2(0,2), global_position, _character.flip_h) 
	
	
func _horizontal_movement() -> void:
	var _direction := Input.get_axis("move_left", "move_right") 
	
	if _direction:
		velocity.x = _direction * _speed
	else:
		velocity.x = move_toward(velocity.x, 0, _speed)
	pass

func _attack_handler() -> void:
	if not _has_sword:
		return
	if Input.is_action_just_pressed("throw"):
		_character.action_animaton("throw_sword")
		set_physics_process(false)
		update_sword_state(false)
		_has_sword = false 
		return
	
	if Input.is_action_just_pressed("attack") and _on_floor: 
		_attack_animation_handler("attack_",4)
	
	if (
		Input.is_action_just_pressed("attack") 
		and not _on_floor
		and _air_attack_count < 2
	 ): 
		_attack_animation_handler("air_attack_",3, true) 

func throw_sword(_is_flipped:bool) -> void:
	var _sword: CharacterSword = _THROWABLE_SWORD.instantiate() 
	get_tree().root.call_deferred("add_child", _sword)
	_sword.global_position = global_position
	
	if _is_flipped:
		_sword.direction = Vector2(-1,0)
	
	_sword.direction = Vector2(1,0)
	

func update_sword_state(_state: bool) -> void:
	_has_sword = _state
	_character.update_suffix(_has_sword)
	
func update_health(_value: int, _entity) -> void:
	_character_health -= _value
	if _character_health <= 0:
		pass
	pass

func _attack_animation_handler(_prefix:String, _index_limit: int, _on_air: bool = false) -> void:
	global.spawn_effect(
			"res://visual_effects/sword/" +
			_prefix  + str(_attack_index) +
			"/" + _prefix   + str(_attack_index) + ".tscn", 
			Vector2(24,0), global_position, _character.flip_h)
	
	_character.action_animaton(_prefix + str(_attack_index))
	_attack_index += 1 
	if _attack_index == _index_limit:
		_attack_index = 1
		
	if _on_air:
		_air_attack_count += 1
	
	set_physics_process(false)
	_attack_combo.start()
	
func _on_attack_combo_timeout() -> void:
	_attack_index = 1
