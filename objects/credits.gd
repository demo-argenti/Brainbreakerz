extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _process(delta):
	
	if $AudioStreamPlayer.playing == false:
		$AudioStreamPlayer.play()
	pass

func _on_back_button_pressed() -> void:
	Transition.transition("res://objects/Main_Menu.tscn")
	pass # Replace with function body.
