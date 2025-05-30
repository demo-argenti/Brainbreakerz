extends Control

@onready var start = $Start
@onready var loop = $Loop

func _ready():
	start.play()

func _process(delta) -> void:
	
	if start.playing == false && loop.playing == false:
		loop.play()
	pass

func _on_retry_pressed() -> void:
	Transition.transition(Global.current_level)


func _on_main_menu_button_pressed() -> void:
	Transition.transition("res://objects/Main_Menu.tscn")



func _on_main_menu_pressed() -> void:
	Transition.transition("res://objects/Main_Menu.tscn")
	
