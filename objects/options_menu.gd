extends Control

const calibration_track : SongDef = preload("uid://qhomvsxd0ehn")

func _ready() -> void: pass


func _process(delta: float) -> void: pass


# Dimmer also serves to block mouse events to the back button
func _on_volume_button_pressed() -> void: $Dimmer.show()
func _on_vol_back_button_pressed() -> void: $Dimmer.hide()


func _on_back_button_pressed() -> void: Transition.transition("res://objects/Main_Menu.tscn")


func _on_calibrate_button_pressed() -> void:
	if true:#Calibration.audio_latency == 0.0: # First-time calibration
		Global.queued_song = calibration_track
		Global.queued_chart_idx = 0
		# remember: calibration scene just uses the ingame_scene.gd to avoid a lot of duplicate script
		Transition.transition("res://Levels/calibration_scene.tscn",true)
	else:
		pass # TODO manual latency adjustment menu
		# (also make it pop up when exiting first-time calib)
