extends Node


func change_scene(scenepath):
	get_tree().change_scene_to_file(scenepath)
