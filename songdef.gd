@tool
class_name SongDef extends Resource


@export var song_title : String
@export var song_artist : String
# we're gonna have to figure this one out better when we get to it
# ultimately, this should be a stream accompanying the definition within the compressed file.
@export_file("*.wav","*.ogg","*.mp3") var audio_file : String
## for each entry, x = bpm, y = offset (for now. is vec2 the way to go?)
## WARNING variable bpm is yet unimplemented!
var bpms : Array[Vector2]
@export var bpm : float = 120.0:
	set(value):
		assert(value > 0.0)
		bpm = value
@export var first_beat_offset : float ## Provided in seconds from stream start.
@export var charts : Array[ChartDef]
@export var events : Dictionary[String,String]

## would be nice to have a tooltip on this.
## can read from .sm files as well as .json files.
@export_tool_button("Get Info From File") var add_chart := _add_chart_callback
@export_tool_button("  Save Out To File  ")\
		var save_chart := _save_chart


func _save_chart():
	var file = FileAccess.open("res://Song Charts/"+song_title+".json",
								FileAccess.WRITE)
	file.store_string(JSON.stringify(_to_dict()))


func _add_chart_callback():
	#var undo_redo = EditorInterface.get_editor_undo_redo()
	#undo_redo.create_action("Add New Chart to %s" % song_title)
	#undo_redo.add_do_method(self, &"_add_chart")
	#undo_redo.add_undo_method(self, &"_pop_chart") # not great... the above can fail
	#undo_redo.commit_action()
	_add_charts()

func _add_charts():
	var dialog = EditorFileDialog.new()
	dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	dialog.current_dir = "res://Song Charts/"
	dialog.set_filters(["*.sm,*.json,*.bbc,*.bbs;BrainBreakerz Chart Files"])
	
	dialog.file_selected.connect(_dialog_ended)
	dialog.canceled.connect(_dialog_ended)
	
	EditorInterface.get_base_control().add_child(dialog)
	dialog.popup_file_dialog()
	
	var filename : String = await(dialog_closed)
	
	if !filename.is_empty():
		#var new_charts = ChartDef.pull_charts_from_file(filename)
		#charts.append_array(new_charts)
		fillout_from_file(filename)
		notify_property_list_changed()
	else: print("whoops! you have to put the cd in your computer")
	
	dialog.file_selected.disconnect(_dialog_ended)
	dialog.canceled.disconnect(_dialog_ended)
	dialog.queue_free()

# this is temp. songs will ultimately exist as compressed files
# containing a json definition and an audio stream.
func fillout_from_file(filename:String) -> bool:
	if filename.ends_with(".sm"):
		var reader := SM_Reader.new()
		reader.filename = filename.split("/")[-1].trim_suffix(".sm") # lol. lmao
		reader.set_file()
		reader.read_file()
		
		song_title = reader.title
		song_artist = reader.artist
		audio_file = reader.song_file
		print_rich("[color=yellow]remember to correct the audio file path before saving out![/color]")
		bpm = reader.bpms[0]["bpm"]
		first_beat_offset = reader.offset
		charts = []
		for chart_dict in reader.charts: charts.append(ChartDef.from_dict(chart_dict))
		
		reader.free()
		
		return true
	
	assert(filename.ends_with(".json")) # for now
	var json = FileAccess.get_file_as_string(filename)
	if FileAccess.get_open_error() != OK:
		push_error(error_string(FileAccess.get_open_error()))
		return false
	return fillout_from_dict(json)


func fillout_from_dict(json:String) -> bool:
	var dict = JSON.parse_string(json)
	if dict==null: return false
	dict = dict as Dictionary
	
	song_title        = dict.get("song_title", "")
	song_artist       = dict.get("song_artist","unattributed!")
	audio_file        = dict.audio_file # this has to exist
	bpm               = dict.get("bpm",0.0)
	first_beat_offset = dict.get("first_beat_offset",0.0)
	charts = []
	for chart_dict in dict.charts: charts.append(ChartDef.from_dict(chart_dict))
	
	return true



signal dialog_closed(fn:String)
func _dialog_ended(fn:String=""): dialog_closed.emit(fn)

func _to_dict() -> Dictionary:
	var chartlist = []
	for chart in charts: chartlist.append(ChartDef.to_dict(chart))
	return {
		"song_title" : song_title,
		"audio_file": audio_file,
		"bpm": bpm, # change this
		"first_beat_offset": first_beat_offset,
		"charts": chartlist,
		"events": events,
	}

#func _pop_chart():
	#charts.pop_back()
	#notify_property_list_changed()
