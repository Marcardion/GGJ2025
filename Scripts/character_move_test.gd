extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -1000.0


func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

# Movimento setinhas personagem
	if Input.is_key_pressed(KEY_LEFT):
		get_node("character_anim").animation="walk"
		get_node("character_anim").scale=Vector2(1,1)
	elif Input.is_key_pressed(KEY_RIGHT):
		get_node("character_anim").animation="walk"
		get_node("character_anim").scale=Vector2(-1,1)
	else:
		get_node("character_anim").animation="idle"

# Movimento pulo e queda do personagem
	if not is_on_floor():
		if velocity.y < 0:
			get_node("character_anim").animation="jump"
		else:
			get_node("character_anim").animation="fall"
