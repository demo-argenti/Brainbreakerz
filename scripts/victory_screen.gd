extends Control

@onready var start = $Start
@onready var loop = $Loop

func _ready() -> void:
	#$Transition.fade_in()
	$CanvasLayer/Score.text = "Score: " + str(Global.level_score) + " pts"
	$CanvasLayer/HighScore.text = "High Score: " + str(Global.high_score) + " pts"
	start.play()

func _process(delta) -> void:
	if start.playing == false && loop.playing == false:
		loop.play()


func _on_main_menu_button_pressed() -> void:
	Global.is_high_score = false
	Global.high_score = 0
	Transition.transition("res://objects/Main_Menu.tscn")
