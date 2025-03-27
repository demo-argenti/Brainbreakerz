extends Control

@onready var start = $Start
@onready var loop = $Loop

func _ready():
	#$Control/CanvasLayer/Score.text = str(Global.level_score) + " pts"
	start.play()

func _process(delta):
	
	if start.playing == false && loop.playing == false:
		loop.play()
	pass

func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://objects/Main_Menu.tscn")
	
