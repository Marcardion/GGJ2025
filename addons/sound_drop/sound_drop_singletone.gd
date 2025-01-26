extends Node

const PachinkoScene = preload("./simulation/pachinko.tscn")


func _ready() -> void:
	var pachinko = PachinkoScene.instantiate()
	pachinko.position = Vector2.DOWN * 5000
	add_child(pachinko)
