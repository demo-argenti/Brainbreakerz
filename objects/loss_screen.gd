extends Control

@onready var start = $Start
@onready var loop = $Loop

func _ready():
	start.play()

func _process(delta):
	
	if start.playing == false && loop.playing == false:
		loop.play()
	pass

func _on_retry_pressed() -> void:
	get_tree().change_scene_to_file(Global.current_level)


func _on_main_menu_pressed() -> void:
	Transition.transition("res://objects/Main_Menu.tscn")
	
	
