extends Control

@onready var start = $Start
@onready var loop = $Loop

#can be used to display a high score message
var is_new_high_score = false

func _ready() -> void:
	var data = null
	if (ResourceLoader.exists("user://SaveFile.tres")):
		data = ResourceLoader.load("user://SaveFile.tres")
	else:
		data = SaveDataResource.new()
	#$Transition.fade_in()
	var high_score = data.get_level_high_score(Global.current_level)
	if (high_score < Global.level_score):
		is_new_high_score = true
		high_score = Global.level_score
		data.set_level_high_score(Global.current_level, Global.level_score)
	data.set_level_finished(Global.current_level, true)
	
	ResourceSaver.save(data, "user://SaveFile.tres")
	$CanvasLayer/Score.text = "Score: " + str(Global.level_score) + " pts"
	$CanvasLayer/HighScore.text = "High Score: " + str(high_score) + " pts"
	start.play()

func _process(delta) -> void:
	if start.playing == false && loop.playing == false:
		loop.play()


func _on_main_menu_button_pressed() -> void:
	Global.is_high_score = false
	Global.high_score = 0
	Global.current_level = -1
	Global.level_score = 0
	Transition.transition("res://objects/Main_Menu.tscn")
