extends Control

@onready var Slide1 = $TImage1
@onready var Slide2 = $TImage2
@onready var Slide3 = $TImage3
@onready var Button1 = $Slide_1_Button
@onready var ButtonB2 = $Slide_2_Back_Button
@onready var ButtonF2 = $Slide_2_Forward_Button
@onready var Button3 = $Slide_3_Back_Button
@onready var Play = $Play


func _process(delta: float) -> void:
	if $AudioStreamPlayer.playing == false:
		$AudioStreamPlayer.play()
	pass


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/Warmin' Up.tscn")
	pass 


func _on_slide_1_button_pressed() -> void:
	Slide1.hide()
	Button1.hide()
	Slide3.hide()
	Button3.hide()
	Play.hide()
	
	Slide2.show()
	ButtonB2.show()
	ButtonF2.show()


func _on_slide_2_back_button_pressed() -> void:
	Slide2.hide()
	ButtonB2.hide()
	ButtonF2.hide()
	Slide3.hide()
	Button3.hide()
	Play.hide()
	
	Slide1.show()
	Button1.show()


func _on_slide_2_forward_button_pressed() -> void:
	Slide2.hide()
	ButtonB2.hide()
	ButtonF2.hide()
	Slide1.hide()
	Button1.hide()
	Play.hide()
	
	Slide3.show()
	Button3.show()
	Play.show()


func _on_slide_3_back_button_pressed() -> void:
	Slide1.hide()
	Button1.hide()
	Slide3.hide()
	Button3.hide()
	Play.hide()
	
	Slide2.show()
	ButtonB2.show()
	ButtonF2.show()
