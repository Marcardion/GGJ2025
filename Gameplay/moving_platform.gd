extends Node2D
#Constante
const WAIT_DURATION := 1.0
#Export variables
@onready var plataform := $plataformBody as AnimatableBody2D
@export var move_speed := 3.0
@export var distance := 500
@export var move_horizontal := true
#centralização da plataforma
var follow := Vector2.ZERO
var plataform_center := 128
#funções de movimentação e callback
func end_movimment():
	move_plataform()
func _ready() -> void:
	move_plataform()

func _physics_process(delta: float) -> void:
	plataform.position = plataform.position.lerp(follow, 0.5)

#função de movimentação
func move_plataform():
	var move_direction = Vector2.RIGHT * distance if move_horizontal else Vector2.UP * distance
	var duration = move_direction.length() / float(move_speed * plataform_center)
	
	var plataform_tween = create_tween()
	plataform_tween.tween_property(self, "follow",move_direction, duration)
	plataform_tween.tween_property(self, "follow",Vector2.ZERO, duration)
	plataform_tween.tween_callback(end_movimment)
