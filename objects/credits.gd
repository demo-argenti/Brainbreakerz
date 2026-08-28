extends Control


func _ready() -> void: pass


func _process(delta): pass
	#if $AudioStreamPlayer.playing == false:
		#$AudioStreamPlayer.play()

func _on_back_button_pressed() -> void:
	Transition.transition("res://objects/Main_Menu.tscn")
