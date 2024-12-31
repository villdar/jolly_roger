extends Area2D


@export var _splash: PackedScene
@onready var _sfx: AudioStreamPlayer2D = $AudioStreamPlayer2D


func _spaw_splash(x: float):
	var splash = _splash.instantiate()
	add_child(splash)
	splash.global_position.x = x
	_sfx.play()


func _on_body_entered(body: Node2D) -> void:
	_spaw_splash(body.position.x)
	if body is Character:
		body.enter_water(position.y)


func _on_body_exited(body: Node2D) -> void:
	if body is Character:
		if body.position.y - float(Global.pixel_per_tile) / 2 <= position.y:
			body.exit_water()
			_spaw_splash(body.position.x)
		else:
			body.dive()
