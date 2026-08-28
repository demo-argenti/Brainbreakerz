extends Control

func _ready() -> void: hide()


func _process(delta: float) -> void:
	if visible:
		$FPSLabel.text = "%.0f FPS\nΔ %.3f ms" % [ Global.fps, delta*1000.0 ]
		$SongPosLabel.text = "%.3fBPM\n%.3f" % [ Conductor.bpm, Conductor.precise_song_pos(true) ]
		var song := "~~~~" if (Global.current_song == null) else Global.current_song.song_title
		$CurrentSongLabel.text = "%s\n%d" % [ song, Global.current_chart_idx ]
		if Global.queued_song != null:
			$CurrentSongLabel.text += "\nQ: %s\n%d" % [ Global.queued_song.song_title, Global.queued_chart_idx ]


func _input(event: InputEvent) -> void:
	event = event as InputEventKey
	if event==null or !event.pressed: return
	
	match event.key_label:
		KEY_BACKSLASH: visible = !visible
		KEY_A: visible = !visible
