extends Node

const CONSTS = preload("./simulation/simulation_consts.gd")

const Pachinko = preload("./simulation/pachinko.gd")
const PachinkoScene = preload("./simulation/pachinko.tscn")
var _pachinko : Pachinko


func max_heat_then_reset() -> void:
	_pachinko.max_heat_then_reset()


func reset_then_max_heat() -> void:
	_pachinko.reset_then_max_heat()


func reset() -> void:
	_pachinko.reset()


func _ready() -> void:
	_pachinko = PachinkoScene.instantiate()
	_pachinko.position = Vector2.DOWN * 5000
	add_child(_pachinko)
	
	set_process_input(CONSTS.IS_DEBUG)


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_0:
			max_heat_then_reset()
		if event.keycode == KEY_9:
			reset_then_max_heat()
		if event.keycode == KEY_8:
			reset()
