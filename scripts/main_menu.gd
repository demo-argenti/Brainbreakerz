extends Control


func _on_tutorial_button_pressed() -> void:
	#$Transition.fade_out()

	Transition.transition("res://objects/Tutorial_Info.tscn")


	#get_tree().change_scene_to_file("res://Levels/Warmin' Up.tscn")
	

func _on_play_demo_button_pressed() -> void:

	Transition.transition("res://objects/Hard_Song_Select.tscn")



func _on_credits_button_pressed() -> void:
	Transition.transition("res://objects/Credits.tscn")
	pass # Replace with function body.


func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _process(delta):
	
	if $AudioStreamPlayer.playing == false:
		$AudioStreamPlayer.play()
	pass

func _on_qa_button_pressed() -> void:
	OS.shell_open("https://docs.google.com/forms/d/1kDReHlWBeEDErFsOjzE4iWz2_2Z_-Y_64WP_xpmM_dw/edit?usp=drivesdk")
	pass # Replace with function body.
