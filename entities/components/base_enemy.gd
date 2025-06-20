extends CharacterBody2D

class_name BaseEnemy

const _COLLECTABLE_ITEM: PackedScene = preload("res://collectables/components/collectable_item.tscn")
enum _types {
	STATIC = 0,
	CHASE = 1,
	WANDER = 2
}

var _on_knockback: bool = false
var _on_floor: bool = false
var _is_alive: bool = true
var _direction: Vector2 = Vector2.ZERO
var _player_in_range: BaseCharacter = null
var _can_play_dead_ground_animation: bool = true

var _drop_items_list: Dictionary = {}

@export_category("Objects")
@export var _enemy_texture: EnemyTexture
@export var _floor_detection_ray: RayCast2D
@export var _knockback_timer: Timer

@export_category("Variables")
@export var is_pink_star: bool = false
@export var _enemy_types: _types
@export var _move_speed: float = 128.0
@export var _knockback_speed: float = 256.0
@export var _enemy_health: int = 10
@export var _hit_knockback_timer: float = 0.4
@export var _dead_knockback_timer: float = 0.4

func _ready() -> void:
	_direction = [Vector2(-1,0), Vector2(1,0)].pick_random()
	_drop_items_list = _get_drop_items()
	_update_direction()

func _get_drop_items() -> Dictionary:
	return {}

func _process(_delta: float) -> void:
	if _on_knockback:
		move_and_slide()

func _physics_process(_delta: float) -> void: 
	_vertical_movement(_delta) 
	if _is_alive == false:
		move_and_slide()
		return
	
	if is_instance_valid(_player_in_range):
		_attack()
		return
	
	match _enemy_types:
		_types.STATIC:
			print("Estatico")
			 
		_types.CHASE:
			print("Chase")
			 
		_types.WANDER:
			_wandering()
	move_and_slide()
	_enemy_texture.animate(velocity)

func _vertical_movement(_delta: float) -> void:
	if is_on_floor():
		if _is_alive == false:
			if _can_play_dead_ground_animation:
				_enemy_texture.action_animate("dead_ground")
				_can_play_dead_ground_animation = false
				
			velocity.x = 0
			return
			
		if _on_floor == false:
			_enemy_texture.action_animate("land")
			_on_floor = true
	
	if not is_on_floor():
		_on_floor = false
		velocity += get_gravity() * _delta  
	
func _wandering() -> void:
	if _floor_detection_ray.is_colliding():
		if _floor_detection_ray.get_collider() is TileMap:
			velocity.x = _direction.x * _move_speed
			return
	if is_on_floor():
		_update_direction()
		velocity.x = 0

func _update_direction() -> void: 
	_direction.x =  -_direction.x 
	if is_pink_star:
		if _direction.x > 0:
			_enemy_texture.flip_h = true
			
		if _direction.x < 0:
			_enemy_texture.flip_h = false
			
	if _direction.x > 0:
		_floor_detection_ray.position.x = 12 
		
	if _direction.x < 0:
		_floor_detection_ray.position.x = -12 

func _attack() -> void:
	pass
	
func update_health(_damage: int, _entity)-> void:
	if _is_alive == false:
		return
		
	_knockback(_entity)
	_enemy_health -= _damage
	
	if _enemy_health <= 0:
		_knockback_timer.start(_dead_knockback_timer)
		_kill() 
		return
	
	_knockback_timer.start(_hit_knockback_timer)
	_enemy_texture.action_animate("hit")
	
	#print(
		#"Inimigo perdeu "+ str(_damage) + 
		#" pontos de vida. Vida atual " + str(_enemy_health)
	#)

func _knockback(_entity: BaseCharacter) -> void:
	var _knockback_direction: Vector2 = _entity.global_position.direction_to(global_position)
	velocity.x = _knockback_direction.x * _knockback_speed
	velocity.y = -1 * _knockback_speed
	
	_on_knockback = true
	

func _kill() -> void: 
	_enemy_texture.action_animate("dead_hit")
	_is_alive = false
	
	for _item in _drop_items_list:
		var _item_spawn_probability: float = _drop_items_list[_item]["spawn_probability"]
		var _rng: float = randf()
		#print("Rng do item" + str(_rng))
		#print("Prob do item"+ str( _item_spawn_probability))
		
		if _rng < _item_spawn_probability:
			_drop_item(_item, _drop_items_list[_item])
 

func _drop_item(_item_name: String, _item_data: Dictionary) -> void:
	pass

func _on_detection_area_body_entered(_body: Node2D) -> void:
	if _body is BaseCharacter:
		_player_in_range = _body  


func _on_detection_area_body_exited(_body: Node2D) -> void:
	if _body is BaseCharacter:
		_player_in_range = null

func _on_knockback_timer_timeout() -> void:
	_on_knockback = false
