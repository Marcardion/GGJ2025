extends Area2D

@export var respawn: bool
var active = true

func _on_body_entered(_body: Node2D) -> void:
	if(active):
		$PopTimer.start()
	

func _on_pop_timer_timeout():
	print_debug("POP")
	%bubble_anim.play("bubble_pop")
	$StaticBody2D/CollisionShape2D.disabled = true
	active = false

func _on_bubble_anim_animation_finished():
	if(%bubble_anim.animation == "bubble_pop"):
		
		if (respawn == false):
			queue_free()
		else:
			$RespawnTimer.start()


func _on_respawn_timer_timeout():
	%bubble_anim.play("bubble_restore")
	$StaticBody2D/CollisionShape2D.disabled = false
	active = true
