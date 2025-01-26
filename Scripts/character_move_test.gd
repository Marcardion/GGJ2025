extends CharacterBody2D


const SPEED = 450.0
const JUMP_VELOCITY = -1000.0


func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

# Girando o personagem de acordo com a direção
	if velocity.x < 0:
		get_node("character_anim").scale=Vector2(1,1)
	elif velocity.x > 0:
		get_node("character_anim").scale=Vector2(-1,1)
		
# Movimento setinhas personagem
	if is_on_floor():
		if Input.is_action_pressed("left"):
			get_node("character_anim").animation="walk"
		elif Input.is_action_pressed("right"):
			get_node("character_anim").animation="walk"
		else:
			get_node("character_anim").animation="idle"
	else: # Movimento pulo e queda do personagem
		if velocity.y < 0:
			get_node("character_anim").animation="jump"
		else:
			get_node("character_anim").animation="fall"
