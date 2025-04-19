extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _process(delta):
	
	if $AudioStreamPlayer.playing == false:
		$AudioStreamPlayer.play()
	pass


func _on_warmin_up_pressed() -> void:
	
	get_tree().change_scene_to_file("res://Levels/Warmin' Up.tscn")



func _on_raveyard_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/Raveyard.tscn")


func _on_mortally_challenged_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/Mortally Challenged.tscn")


func _on_yatatatata_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/Yatatatata.tscn")


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://objects/Main_Menu.tscn")
	pass # Replace with function body.


func _on_deadlock_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/Deadlock.tscn")
	pass # Replace with function body.
