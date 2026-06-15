extends Control


var menu_music = preload("uid://bp0u4wk5whh88")


func _ready() -> void:
	if Conductor.playing and Conductor.stream.get_rid() == menu_music.get_rid():
		return
	# maybe we could chuck these values in a blank chart
	Conductor.stream = menu_music
	Conductor.bpm = 85
	Conductor.first_beat_offset = 0.032
	Conductor.play()

#func _process(_delta) -> void:
	#if !($AudioStreamPlayer.playing): $AudioStreamPlayer.play()

func _input(event: InputEvent) -> void:
	event = event as InputEventKey
	if event==null: return
	
	match event.key_label:
		KEY_O: Transition.transition("res://objects/options_menu.tscn")


func _on_tutorial_button_pressed() -> void:
	Transition.transition("res://objects/Tutorial_Info.tscn")

func _on_play_demo_button_pressed() -> void:
	Transition.transition("res://objects/Hard_Song_Select.tscn")

func _on_credits_button_pressed() -> void:
	Transition.transition("res://objects/Credits.tscn") 

func _on_quit_button_pressed() -> void: get_tree().quit()

func _on_qa_button_pressed() -> void:
	OS.shell_open("https://docs.google.com/forms/d/1kDReHlWBeEDErFsOjzE4iWz2_2Z_-Y_64WP_xpmM_dw/edit?usp=drivesdk")
