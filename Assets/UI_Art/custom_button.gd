extends Button

signal custom_pressed


func _ready() -> void:
	pressed.connect(on_pressed)
	mouse_entered.connect(grab_focus)

func on_pressed() :
	is_pressed = true
	%AnimationPlayer.animation_finished.connect(on_animation_finished)
	%AnimationPlayer.play("pressed")

func on_animation_finished(anime) :
	custom_pressed.emit()
	

func _process(delta: float) -> void:
	if is_pressed: return
	
	if has_focus():
		if %AnimationPlayer.current_animation !="hover":
			%AnimationPlayer.play("hover")
	else: %AnimationPlayer.play("default")
	
var is_pressed = false
