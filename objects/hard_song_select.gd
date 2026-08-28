extends Control

const vanilla_song_dir := "res://Song Charts"
const song_button = preload("uid://bpkcagiqv86gv")

func _ready() -> void:
	var songs_dir := DirAccess.open(vanilla_song_dir)
	
	for filename in songs_dir.get_files():
		if filename.ends_with(".json"): # TODO decide on a file extension
			var json = FileAccess.get_file_as_string(vanilla_song_dir+"/"+filename)
			if FileAccess.get_open_error() != OK:
				push_error(error_string(FileAccess.get_open_error()))
				continue
			
			var song = SongDef.new()
			if !song.fillout_from_dict(json): continue
			
			var new_button = song_button.instantiate()
			new_button.song = song
			%VBoxContainer.add_child(new_button)


func _on_back_button_pressed() -> void:
	Transition.transition("res://objects/Main_Menu.tscn")
