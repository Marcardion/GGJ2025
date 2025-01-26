extends Marker2D

const Dama := preload("./dama.gd")
const DamaScene := preload("./dama.tscn")

@export var spawner_duration := 4

var _dama_positions := []

@onready var _timer = spawner_duration
var _tracking_dama : Dama


func get_valid_positions() -> Array[Vector2]:
	if _dama_positions.size() == 0:
		return []
	var last = _dama_positions[-1]
	var arr :Array[Vector2] = [last["pos"]]
	
	for i in range(_dama_positions.size()-2, -1, -1):
		if _dama_positions[i]["hits"] != last["hits"]:
			break
		if _dama_positions[i]["pos"].y < _dama_positions[0]["pos"].y + 200:
			continue
		arr.push_back(_dama_positions[i]["pos"])
	return arr

func _draw() -> void:
	for p in _dama_positions:
		draw_circle(p["pos"] - global_position, 2, Color.BLACK)


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


func _on_tracking_dama_position_stepped(pos : Vector2, hits: int, step : int):
	if step >= _dama_positions.size():
		_dama_positions.push_back({"pos": pos, "hits": hits})
	else:
		_dama_positions[step] = {"pos": pos, "hits": hits}
	queue_redraw()


func _on_tracking_dama_lifetime_ended():
	_tracking_dama.position_stepped.disconnect(_on_tracking_dama_position_stepped)
	_tracking_dama.lifetime_ended.disconnect(_on_tracking_dama_lifetime_ended)
	_tracking_dama = null
