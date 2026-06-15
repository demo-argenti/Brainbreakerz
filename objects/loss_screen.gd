extends Control

@onready var start : AudioStreamPlayer = $Start
@onready var loop = $Loop

func _ready():
	start.play()
	start.finished.connect(_on_start_finished)


func _on_start_finished() -> void: loop.play()

func _on_retry_pressed() -> void: pass
	#Transition.transition(Global.current_level) # ?????

func _on_main_menu_button_pressed() -> void:
	Transition.transition("res://objects/Main_Menu.tscn")

func _on_main_menu_pressed() -> void:
	Transition.transition("res://objects/Main_Menu.tscn")
