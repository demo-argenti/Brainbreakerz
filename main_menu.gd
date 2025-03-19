extends Control


func _on_tutorial_button_pressed() -> void:
	get_tree().change_scene_to_file("res://objects/tutorial_level.tscn")

func _on_play_demo_button_pressed() -> void:
	pass # Replace with function body.


func _on_credits_button_pressed() -> void:
	pass # Replace with function body.


func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _process(delta):
	
	if $AudioStreamPlayer.playing == false:
		$AudioStreamPlayer.play()
	pass
