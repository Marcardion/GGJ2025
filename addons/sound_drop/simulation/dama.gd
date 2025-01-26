extends RigidBody2D

const SoundManager := preload("sound_manager.gd")
const CONSTS := preload("./simulation_consts.gd")

signal position_stepped
signal lifetime_ended

@onready var _hits := 0
var _sound_manager : SoundManager
var _initialized := false
var _life_timer := 0.0
var _position_step := 0

func initialize(sound_manager : SoundManager):
	_sound_manager = sound_manager
	_initialized = true


func _process(delta: float) -> void:
	_life_timer += delta
	var step = floori(_life_timer / 0.1)
	if step != _position_step:
		_position_step = step
		position_stepped.emit(global_position, _hits, _position_step)
	if _life_timer > CONSTS.DAMA_LIFETIME:
		lifetime_ended.emit()
		queue_free()


func _ready() -> void:
	add_to_group("_uninitialized_damas")
	body_entered.connect(_on_body_entered)


func _on_body_entered(body) -> void:
	if _initialized and body is StaticBody2D:
		_hits += 1
		_sound_manager.queue_sound({
			"position": global_position,
			"hits": _hits
		})
