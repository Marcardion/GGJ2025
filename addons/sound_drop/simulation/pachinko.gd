extends Node2D

const Spawner = preload("./spawner.gd")
const SpawnerScene = preload("./spawner.tscn")

const BouncerScene = preload("./bouncer.tscn")

const UPDATE_PACHINKO_REFRESH_TIMER = 5.0

@export var notes_width = 40
@export var spawners_target = 1
@export var notes_target = 1

@onready var spawners : Array[Spawner] = []
@onready var bouncers : Array[Node] = []
@onready var _refresh_timer = 0.0
@onready var safe_bouncers : Dictionary = {}
@onready var _notes_played_since_last_refresh = 0


func refresh() -> void:
	print("refreshed")
	if spawners_target > spawners.size():
		create_new_spawner()
	elif spawners_target < spawners.size():
		spawners.shuffle()
		var spawner = spawners.pop_front()
		safe_bouncers[spawner].queue_free()
		safe_bouncers.erase(spawner)
		spawner.queue_free()
	
	if notes_target >= _notes_played_since_last_refresh:
		create_random_bouncer()
		create_random_bouncer()
	else:
		remove_random_bouncer()
	
	_notes_played_since_last_refresh = 0


func on_played_node():
	_notes_played_since_last_refresh += 1


func remove_random_bouncer():
	print("remove_random_bouncer")
	
	if bouncers.size() == 0:
		return
	
	bouncers.shuffle()
	var bouncer = bouncers.pop_front()
	bouncer.queue_free()


func create_random_bouncer():
	print("create_random_bouncer")
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
	spawner.position = Vector2(randf()*notes_width*12, 0)
	spawners.push_back(spawner)
	add_child(spawner)
	
	var bouncer = BouncerScene.instantiate()
	bouncer.position = spawner.position + Vector2(-40 + randf()*20, 200)
	add_child(bouncer)
	
	safe_bouncers[spawner] = bouncer


func _ready() -> void:
	%SoundManager.setup(global_position, notes_width)
	%SoundManager.played_note.connect(on_played_node)
	refresh()


func _physics_process(delta: float) -> void:
	var uninitialized_damas = get_tree().get_nodes_in_group("_uninitialized_damas")
	for d in uninitialized_damas:
		d.initialize(%SoundManager)
		d.remove_from_group("_uninitialized_damas")
	
	_refresh_timer += delta
	if _refresh_timer > UPDATE_PACHINKO_REFRESH_TIMER:
		_refresh_timer -= UPDATE_PACHINKO_REFRESH_TIMER
		refresh()
