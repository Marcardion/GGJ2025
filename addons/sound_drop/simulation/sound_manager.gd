extends Node

const CONSTS = preload("simulation_consts.gd")

signal played_note

@onready var _players : Array[AudioStreamPlayer] = []

var _notes_origin : Vector2
var _notes_width : float
var _scale_freq : Array[float] = []
var _note_to_scale : Dictionary = {}


func setup(origin: Vector2, notes_width: float) -> void:
	_notes_origin = origin
	_notes_width = notes_width
	
	for i in range(CONSTS.NOTE_FREQS.size()):
		if CONSTS.SCALE.has(i % 12):
			_scale_freq.push_back(CONSTS.NOTE_FREQS[i])


func queue_sound(params) -> void:
	for player in _players:
		if not player.playing:
			play_sound(player, params)
			return
	
	var player = AudioStreamPlayer.new()
	add_child(player)
	play_sound(player, params)
	_players.push_back(player)


func play_sound(player : AudioStreamPlayer, params) -> void:
	player.stream = CONSTS.C_PIANO_SOUND
	var note_x = params["position"].x - _notes_origin.x
	var note = floori(note_x / _notes_width) + CONSTS.SCALE.size()
	note = clamp(note, 0, _scale_freq.size()-1)
	player.pitch_scale = _scale_freq[note]
	player.volume_db = -(params["hits"] - 1) * 4
	player.bus = "SoundDrop"
	
	player.play()
	
	played_note.emit()
