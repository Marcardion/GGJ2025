extends Area2D



func _on_body_entered(body: Node2D) -> void:
	$Timer.start()
	$StaticBody2D/CollisionShape2D/bubble_anim.play("bubble_pop")

func _on_timer_timeout() -> void:
	queue_free()
