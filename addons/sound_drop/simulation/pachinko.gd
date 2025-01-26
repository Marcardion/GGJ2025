extends Node2D

const Spawner = preload("./spawner.gd")
const SpawnerScene = preload("./spawner.tscn")
const BouncerScene = preload("./bouncer.tscn")

const CONSTS = preload("simulation_consts.gd")


@export var spawners_target = 1
@export var notes_target = 1

@onready var spawners : Array[Spawner] = []
@onready var bouncers : Array[Node] = []
@onready var _refresh_timer = 0.0
@onready var safe_bouncers : Dictionary = {}

@onready var _override_heat = -1.0
@onready var _heat_timer = 0.0
@onready var _notes_played_since_last_refresh = 0
@onready var _auto_refreshing = true

func reset() -> void:
	for i in range(spawners.size()):
		remove_random_spawner()
	
	for i in range(bouncers.size()):
		remove_random_bouncer()
	
	_override_heat = -1.0
	_refresh_timer = 0.0
	_heat_timer = 0.0
	_auto_refreshing = true
	_refresh()


func reset_then_max_heat() -> void:
	for i in range(spawners.size()):
		remove_random_spawner()
	
	for i in range(bouncers.size()):
		remove_random_bouncer()
	
	_override_heat = 1.0
	
	_refresh()


func max_heat_then_reset() -> void:
	_auto_refreshing = false
	_override_heat = 1.0
	_refresh()
	
	await get_tree().create_timer(2.0).timeout
	
	reset()


func get_current_heat() -> float:
	if _override_heat >= 0.0:
		return _override_heat
	return (-cos(_heat_timer*2*PI/CONSTS.PACHINKO_HEAT_PERIOD)+1)/2.0


func _refresh() -> void:
	var current_heat = get_current_heat()
	spawners_target = 1 + round(current_heat*(CONSTS.PACHINKO_MAX_HEAT_SPAWNERS_TARGET-1))
	notes_target = spawners.size() + round(current_heat*(CONSTS.PACHINKO_MAX_HEAT_SOUNDS_TARGET - spawners.size()))

	while spawners_target >= spawners.size():
		create_new_spawner()
	while spawners_target < spawners.size():
		remove_random_spawner()
	
	if notes_target >= _notes_played_since_last_refresh:
		create_random_bouncer()
		create_random_bouncer()
	elif notes_target < _notes_played_since_last_refresh:
		remove_random_bouncer()
		remove_random_bouncer()

	_notes_played_since_last_refresh = 0


func remove_random_spawner() -> void:
	spawners.shuffle()
	var spawner = spawners.pop_front()
	safe_bouncers[spawner].queue_free()
	safe_bouncers.erase(spawner)
	spawner.queue_free()


func on_played_node():
	_notes_played_since_last_refresh += 1


func remove_random_bouncer():
	if bouncers.size() == 0:
		return
	
	bouncers.shuffle()
	var bouncer = bouncers.pop_front()
	bouncer.queue_free()


func create_random_bouncer():
	var all_points : Array[Vector2] = []
	for spawner in spawners:
		all_points.append_array(spawner._dama_positions)
	
	all_points = all_points.filter(func(v: Vector2): return v.y > 200)
	
	if all_points.size() < 5:
		return
	
	var rand_pos = all_points.pick_random()
	
	var bouncer = BouncerScene.instantiate()
	bouncer.position = rand_pos + Vector2(-40 + randf()*20, -40 + randf()*20)
	bouncers.push_back(bouncer)
	add_child(bouncer)


func create_new_spawner():
	var spawner = SpawnerScene.instantiate()
	spawner.position = Vector2(randf() * CONSTS.PACHINKO_NOTES_WIDTH * (CONSTS.SCALE.size() - 2), 0)
	spawners.push_back(spawner)
	add_child(spawner)
	
	var bouncer = BouncerScene.instantiate()
	bouncer.position = spawner.position + Vector2(-40 + randf()*80, 200)
	add_child(bouncer)
	
	safe_bouncers[spawner] = bouncer


func _ready() -> void:
	%SoundManager.setup(global_position, CONSTS.PACHINKO_NOTES_WIDTH)
	%SoundManager.played_note.connect(on_played_node)
	
	%DebugContainer.visible = CONSTS.IS_DEBUG
	
	_refresh()


func _physics_process(delta: float) -> void:
	var uninitialized_damas = get_tree().get_nodes_in_group("_uninitialized_damas")
	for d in uninitialized_damas:
		d.initialize(%SoundManager)
		d.remove_from_group("_uninitialized_damas")
	
	_heat_timer += delta
	_refresh_timer += delta

	if _refresh_timer > CONSTS.PACHINKO_REFRESH_TIMER:
		_refresh_timer -= CONSTS.PACHINKO_REFRESH_TIMER
		if _auto_refreshing:
			_refresh()

	if CONSTS.IS_DEBUG:
		%DebugLabelHeat.text = "Heat: %f" % get_current_heat()
		%DebugLabelOverrideHeat.text = "Override heat: %f" % _override_heat
		%DebugLabelHeatTimer.text = "Heat timer: %f" % _heat_timer
		%DebugLabelRefreshTimer.text = "Refresh timer: %f" % _refresh_timer
		%DebugLabelSpawnersCount.text = "Spawners: %d" % spawners.size()
		%DebugLabelBouncersCount.text = "Bouncers: %d" % (bouncers.size() + spawners.size())
