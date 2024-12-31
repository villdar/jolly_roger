extends Node

@onready var _character = get_parent()
#@onready var _characters = get_children()

#var current_index = 0

func _input(event: InputEvent) -> void:
	#if current_index < _characters.size():
		#if event.is_action_pressed("shift"):
			#current_index = (current_index + 1) % _characters.size()
	if event.is_action_pressed("jump"):
		_character.jump()
	if event.is_action_released("jump"):
		_character.stop_jump()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#var active_position = _characters[current_index].position
	
	_character.run(Input.get_axis("run_left", "run_right"))
	#%Camera2D.position = active_position
	
	#for i in range (_characters.size()):
		#if i == current_index:
			#pass
		#_characters[i].position = _characters[i].position.move_toward(active_position, 100 * _delta)
