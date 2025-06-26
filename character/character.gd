extends CharacterBody2D

class_name BaseCharacter

const _THROWABLE_SWORD: PackedScene = preload("res://throwables/character_sword/character_sword.tscn")

var _can_play_dead_ground_animation: bool = true
var _on_knockback: bool = false
var _has_sword: bool = false
var _on_floor: bool = true
var _is_alive: bool = true

var _jump_count = 0
var _attack_index: int = 1
var _air_attack_count: int = 0

var _additional_attributes: Dictionary = {
	"move_speed": 0,
	"defense": 0
}

@export_category('Variables')
@export var _speed: float = 200.0
@export var _jump_velocity: float = -300.0 
@export var _character_health: int = 10
@export var _knockback_speed: float = 200.0

@export_category("Objects")
@export var _inventory: CharacterInventory
@export var _attack_combo: Timer
@export var _character_texture: CharacterTexture
@export var _knockback_timer: Timer
@export var _character_camera: Camera2D
@export var _is_in_cinematic: bool = true

func _ready() -> void:
	global.character = self

func play_cinematic_animartion(_anim_name: String) -> void:
	_character_texture.play(_anim_name)

func reset_bonus_attributes() -> void:
	_additional_attributes = {
	"move_speed": 0,
	"defense": 0
}
	
func increase_bonus_attributes(_attributes: Dictionary) -> void:
	for _type in _attributes:
		for _attribute in _attributes[_type]:
			_additional_attributes[_attribute] += _attributes[_type][_attribute]

func disable() -> void:
	_is_alive = false 
	velocity.x = 0
	_character_camera.limit_bottom = int(global_position.y) + int(360.0/2.0)
	transition_screen.fade_in()

func _process(_delta: float) -> void: 
	if _on_knockback: 
		move_and_slide()

func _physics_process(delta: float) -> void: 
	if _is_in_cinematic:
		return
	_vertical_movement(delta) 
	if _is_alive == false or _on_knockback: 
		move_and_slide()
		return
	
	_horizontal_movement()  
	_attack_handler()
	
	move_and_slide()
	
	_character_texture.animate(velocity)

func _vertical_movement(_delta: float) -> void: 
	if is_on_floor():  
		if _is_alive == false:
			if _can_play_dead_ground_animation:
				_character_texture.action_animation("dead_ground")
				_can_play_dead_ground_animation = false
				#_collision.disabled = true
				set_collision_layer_value(1,false)
				set_collision_mask_value(1,false)
				set_collision_layer_value(2,true)
				set_collision_mask_value(2,true)
				
			velocity.x = 0
			return
			
		if _on_floor == false:
			_air_attack_count = 0
			global.spawn_effect(
				"res://visual_effects/dust_particles/fall/fall_effect.tscn", 
				Vector2(0,2), global_position, false
			)
			
			_character_texture.action_animation("land")
			set_physics_process(false)
			_on_floor = true
		
		_jump_count = 0 
	
	if not is_on_floor():
		if is_on_floor:
			_attack_index = 1
		
		_on_floor = false
		velocity += get_gravity() * _delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and _jump_count < 2 and _is_alive:
		_jump_count += 1
		_attack_index = 1
		velocity.y = _jump_velocity
		global.spawn_effect(
			"res://visual_effects/dust_particles/jump/jump_effect.tscn", 
			Vector2(0,2), global_position, _character_texture.flip_h) 
	
	
func _horizontal_movement() -> void:
	var _direction := Input.get_axis("move_left", "move_right") 
	
	if _direction:
		velocity.x = _direction * (_speed + _additional_attributes["move_speed"]) 
		return
	velocity.x = move_toward(velocity.x, 0, _speed)
	

func _attack_handler() -> void:
	if not _has_sword:
		return
	if Input.is_action_just_pressed("throw"):
		_character_texture.action_animation("throw_sword")
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
	_character_texture.update_suffix(_has_sword)
	
func update_health(_value: int, _entity) -> void:
	_knockback(_entity)
	_knockback_timer.start()
	var _new_value: int = _value -  _additional_attributes["defense"]
	_character_health -= _new_value
	
	if _character_health <= 0:
		_is_alive = false
		update_sword_state(false)
		_character_texture.action_animation("dead_hit")
		return
	_character_texture.action_animation("hit")

func _knockback(_entity: BaseEnemy) -> void:
	var _knockback_direction: Vector2 = _entity.global_position.direction_to(global_position)
	velocity.x = _knockback_direction.x * _knockback_speed
	velocity.y = -1 * _knockback_speed
	_on_knockback = true
	
func collect_item(_item:Dictionary)-> void:  
	_inventory.add_item(_item)

func _attack_animation_handler(_prefix:String, _index_limit: int, _on_air: bool = false) -> void:
	global.spawn_effect(
			"res://visual_effects/sword/" +
			_prefix  + str(_attack_index) +
			"/" + _prefix   + str(_attack_index) + ".tscn", 
			Vector2(24,0), global_position, _character_texture.flip_h)

	_character_texture.action_animation(_prefix + str(_attack_index))
	_attack_index += 1 
	if _attack_index == _index_limit:
		_attack_index = 1

	if _on_air:
		_air_attack_count += 1
	
	set_physics_process(false)
	_attack_combo.start()

func _on_attack_combo_timeout() -> void:
	_attack_index = 1

func _on_knockback_timer_timeout() -> void:
	_on_knockback = false

func is_player_alive() -> bool:
	return _is_alive
