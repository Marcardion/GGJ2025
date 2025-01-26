extends Node

const CONSTS = preload("sound_manager_consts.gd")
enum NOTES {A, AS, B, C, CS, D, DS, E, F, FS, G, GS}

signal played_note

@onready var _players : Array[AudioStreamPlayer] = []

var _notes_origin : Vector2
var _notes_width : float


func setup(origin: Vector2, notes_width: float) -> void:
	_notes_origin = origin
	_notes_width = notes_width


func queue_sound(params) -> void:
	for player in _players:
		if not player.playing:
			play_sound(player, params)
			return
	
	var player = AudioStreamPlayer.new()
	add_child(player)
	play_sound(player, params)


func play_sound(player : AudioStreamPlayer, params) -> void:
	player.stream = CONSTS.C_PIANO_SOUND
	var note_x = params["position"].x - _notes_origin.x
	var note = floori(note_x / _notes_width) + CONSTS.MIDDLE_C_FREQ_IDX
	note = clamp(note, 0, CONSTS.NOTE_FREQS.size()-1)
	player.pitch_scale = CONSTS.NOTE_FREQS[note]
	player.play()
	
	played_note.emit()
