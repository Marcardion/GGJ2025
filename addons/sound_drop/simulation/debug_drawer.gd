extends Node2D

var collision_shape : CollisionShape2D

func _ready() -> void:
	for sibling in get_parent().get_children():
		if sibling is CollisionShape2D:
			collision_shape = sibling
	assert(collision_shape != null)

func _draw() -> void:
	var shape : CircleShape2D = collision_shape.shape
	draw_circle(position, shape.radius, Color.LIGHT_BLUE, true)
