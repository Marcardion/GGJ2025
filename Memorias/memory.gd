extends Node2D


@export var memoryname: String

# Called when the node enters the scene tree for the first time.
func _ready():
	Dialogic.start(memoryname)
