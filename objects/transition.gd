extends Node2D

func transition(scene : String):
	$AnimatedSprite2D.play()
	get_tree().change_scene_to_file(scene)
	$AnimatedSprite2D.play_backwards()

func fade_in():
	visible = true
	$AnimatedSprite2D.play()
	
	
func fade_out():
	visible = true
	$AnimatedSprite2D.play_backwards()
	visible = false
