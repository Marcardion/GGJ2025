extends Control



func _on_button_start_pressed():
	Globals.change_scene("res://Levels/Tutorial.tscn")


func _on_button_credits_pressed():
	Globals.change_scene("res://Levels/Credits.tscn")


func _on_button_exit_pressed():
	get_tree().quit()
