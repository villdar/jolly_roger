extends CharacterBody2D



@export_category("Locomotion")
@export var _speed: float = 8
@export var _acceleration: float = 16
@export var _deceleration: float = 32

@export_category("Jump")
@export var _jump_height: float = 2.5
@export var _air_control: float = 0.5
@export var _jump_dust: PackedScene

var _direction: float
var _jump_velocity: float
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var _sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	_speed *= Global.pixel_per_tile
	_acceleration *= Global.pixel_per_tile
	_deceleration *= Global.pixel_per_tile
	_jump_height *= Global.pixel_per_tile
	_jump_velocity = sqrt(_jump_height * gravity * 2) * -1

#region Public Methods

func face_left():
	_sprite.flip_h = true


func face_right():
	_sprite.flip_h = false


func run(direction: float):
	_direction = direction


func jump():
	if is_on_floor():
		velocity.y = _jump_velocity
		_spaw_dust(_jump_dust)


func stop_jump():
	if velocity.y < 0:
		velocity.y = 0

#endregion


func _physics_process(delta: float) -> void:
	if sign(_direction) == -1:
		face_left()
	elif sign(_direction) == 1:
		face_right()
	
	if is_on_floor():
		_ground_physics(delta)
	else:
		_air_physics(delta)
	
	move_and_slide()
	
	
func _ground_physics(delta: float):
	
	# decelerate to zero
	if _direction == 0:
		velocity.x = move_toward(velocity.x, 0, _deceleration * delta)
	# accelerate from not moving, or trying to move in the same direction
	elif velocity.x == 0 or sign(_direction) == sign(velocity.x):
		velocity.x = move_toward(velocity.x, _direction * _speed, _acceleration * delta)
	# decelerate if trying to move in opposite direction
	else:
		velocity.x = move_toward(velocity.x, _direction * _speed, _acceleration * delta)
	

func _air_physics(delta: float):
	# Add the gravity.
	velocity.y += gravity * delta
	if _direction:
		velocity.x = move_toward(velocity.x, _direction * _speed, _acceleration * _air_control * delta)


func _spaw_dust(dust: PackedScene):
	var _dust = dust.instantiate()
	_dust.position = position
	_dust.flip_h = _sprite.flip_h
	get_parent().add_child(_dust)
