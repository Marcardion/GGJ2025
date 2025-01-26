@tool
extends EditorPlugin


func _enter_tree() -> void:
	add_autoload_singleton("SoundDrop", "./sound_drop_singletone.gd")


func _exit_tree() -> void:
	remove_autoload_singleton("SoundDrop")
