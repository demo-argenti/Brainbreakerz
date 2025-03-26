extends Node2D

func _ready():
	$Control/CanvasLayer/Score.text = str(Global.level_score) + " pts"




func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://objects/Main_Menu.tscn")
