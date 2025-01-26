extends Area2D

@export var memoryscene: String


func _on_body_entered(body):
	Globals.change_scene(memoryscene)
