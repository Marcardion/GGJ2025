extends Marker2D

const Dama := preload("./dama.gd")
const DamaScene := preload("./dama.tscn")

@export var spawner_duration := 4

var _dama_positions : Array[Vector2] = []

@onready var _timer = spawner_duration
var _tracking_dama : Dama


func _draw() -> void:
	for pos in _dama_positions:
		draw_circle(pos - global_position, 2, Color.BLACK)


func _physics_process(delta: float) -> void:
	_timer += delta
	if _timer > spawner_duration:
		_timer -= spawner_duration
		var new_dama = DamaScene.instantiate()
		add_child(new_dama)
		if _tracking_dama == null:
			_tracking_dama = new_dama
			_tracking_dama.position_stepped.connect(_on_tracking_dama_position_stepped)
			_tracking_dama.lifetime_ended.connect(_on_tracking_dama_lifetime_ended)


func _on_tracking_dama_position_stepped(pos : Vector2, step : int):
	if step >= _dama_positions.size():
		_dama_positions.push_back(pos)
	else:
		_dama_positions[step] = pos
	queue_redraw()


func _on_tracking_dama_lifetime_ended():
	_tracking_dama.position_stepped.disconnect(_on_tracking_dama_position_stepped)
	_tracking_dama.lifetime_ended.disconnect(_on_tracking_dama_lifetime_ended)
	_tracking_dama = null
