extends Control


func _on_tutorial_button_pressed() -> void:
<<<<<<< Updated upstream
	get_tree().change_scene_to_file("res://Levels/tutorial_level.tscn")
=======
	#$Transition.fade_out()
	get_tree().change_scene_to_file("res://objects/Tutorial_Info.tscn")
>>>>>>> Stashed changes

func _on_play_demo_button_pressed() -> void:

	get_tree().change_scene_to_file("res://objects/Song_Select.tscn")



func _on_credits_button_pressed() -> void:
	get_tree().change_scene_to_file("res://objects/Credits.tscn")
	pass # Replace with function body.


func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _process(delta):
	
	if $AudioStreamPlayer.playing == false:
		$AudioStreamPlayer.play()
	pass
<<<<<<< Updated upstream
=======

func _on_qa_button_pressed() -> void:
	OS.shell_open("https://forms.gle/RyNHuYtA4grdAQdC8")
	pass # Replace with function body.
>>>>>>> Stashed changes
