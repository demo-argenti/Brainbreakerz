extends Control

func _on_retry_pressed() -> void:
	get_tree().change_scene_to_file(Global.current_level)


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://objects/Main_Menu.tscn")
