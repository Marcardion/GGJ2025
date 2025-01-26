extends Control

func _ready() -> void:
	%ButtonStart.grab_focus()

func _on_button_start_pressed():
	Globals.change_scene("res://Levels/Tutorial.tscn")

func _on_button_credits_custom_pressed():
	Globals.change_scene("res://Levels/Credits.tscn")

func _on_button_exit_pressed():
	get_tree().quit()
