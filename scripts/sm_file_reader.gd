extends Node

@export var filename : String

var file : FileAccess

var song_file : String
var title : String
var subtitle : String
var artist : String
var sample_start : float
var sample_length : float
var offset : float
var bpms : Array
var charts : Array

# Called when the node enters the scene tree for the first time.
func _ready():
	set_file()
	read_file()

func set_file():
	file = FileAccess.open(filename, FileAccess.READ)
	if file == null:
		var error_str: String = error_string(FileAccess.get_open_error())
		push_warning("Couldn't open file because: %s" % error_str)


func read_file():
	var line : String
	var string_holder : String
	
	var var_name : String
	var char : String
	
	var is_searching_for_var_name = true
	
	var is_searching_for_bpms = false
	var is_searching_for_notes = false
	
	var bpm_holder : float
	var beat_holder : float
	
	var current_line : int = 0
	
	var bar_holder : String
	
	var chart_name_holder : String
	var notes_holder : Array

	
	while file.get_position() < file.get_length():
		line = file.get_line()
		
		string_holder = ""
		
		# handles everything except the note chart itself
		if not is_searching_for_notes:
			for i in line.length():
				char = line[i]
				
				# if you're searching for bpm changes, keep going until you find a
				# "=", ",", or ";" character, then store the data you have in the proper place
				if is_searching_for_bpms:
					#if we found a "=", store data as a bpm
					if char == "=":
						bpm_holder = string_holder.to_float()
						string_holder = ""
					#if we found a "," or a ";", store data as a beat
					elif char == "," or char == ";":
						beat_holder = string_holder.to_float()
						bpms.push_back({"bpm" : bpm_holder, "beat" : beat_holder})
					else:
						string_holder += char
				else: 
					# don't add ";" to string_holder
					if char != ";":
						string_holder += char
				
					# make sure the parser ignores comments, break out of string to ensure it does
					if string_holder == "//":
						break
				
					# once ":" is found, we have found the variable name. 
					# find the appropriate variable and begin parsing variable data	
					if char == ":":
						is_searching_for_var_name = false
						var_name = string_holder
						string_holder = ""
						
						#check to see if we are looking for bpms or notes now
						match var_name:
							"#BPMS:":
								is_searching_for_bpms = true
							"#NOTES:":
								is_searching_for_notes = true
								break

				# once ";" is reached at the end of a line, we're at the end of a varaible value, and it's time
				# to store that data in a varaible. This match case statement puts it in the right variable
				if char == ";" and i == line.length()-1:
					is_searching_for_bpms = false
					match var_name:
						"#TITLE:":
							title = string_holder
						"#SUBTITLE:":
							subtitle = string_holder
						"#ARTIST:":
							artist = string_holder
						"#MUSIC:":
							song_file = string_holder
						"#SAMPLESTART:":
							sample_start = string_holder.to_float()
						"#SAMPLELENGTH:":
							sample_length = string_holder.to_float()
						"#OFFSET:":
							offset = string_holder.to_float()
		else:
			if line.begins_with("//"):
				continue
				
			if current_line < 5:
				line = line.dedent()
				if _is_challenge_level(line):
					line.erase(line.find(":"))
					chart_name_holder = line
				current_line += 1
			else:
				if !line.begins_with(",") and !line.begins_with(";"):
					bar_holder += line
				else:
					notes_holder.push_back(bar_holder)
					bar_holder = ""
					
					# once ";" is reached, adds a dict containing the parsed note chart to charts
					if line.begins_with(";"):
						is_searching_for_notes = false
						is_searching_for_var_name = true
						charts.push_back(_parse_note_inputs(chart_name_holder, notes_holder))
					
				
# determines whether str is a valid challenge level
func _is_challenge_level(str : String) -> bool:
	if str == "Beginner:" or str == "Easy:" or str == "Medium:" or str == "Hard:" or str == "Challenge:" or str == "Edit:":
		return true
	return false
	
# returns a dictionary containing the difficulty of the chart, and arrays holding the notes for each track	
func _parse_note_inputs(chart_name : String, notes_holder : Array):
	var track_1 : Array
	var track_2 : Array
	var track_3 : Array
	
	# this is how the current bar is subdivided (4 quarters, 8 eitgthths, 16 sixteenths, etc.)
	var bar_subdivision : float
	
	# this is the length of the smallest subdivision in a given bar in beats
	var bar_note_length : float
	
	# this holds a reference to the current track the parser is on so it can store values there
	var current_track : Array
	
	# counts how many beats we encountered in the previous loops
	var beat_running_total : float = 0.0
	
	
	for bar in notes_holder:
		bar_subdivision = bar.length() / 4.0
		bar_note_length = 4.0 / bar_subdivision
		
		for i in bar.length():
			var track = i % 4
			var note = (i / 4)
			
			match track:
				0:
					current_track = track_1
				1:
					continue
				2:
					current_track = track_2
				3:
					current_track = track_3
			
			match bar[i].to_int():
				0:
					continue
				1:
					current_track.push_back({"is_held_note" : false, "landing_beat" : (note * bar_note_length) + beat_running_total})
				2:
					current_track.push_back({"is_held_note" : true, "landing_beat" : (note * bar_note_length) + beat_running_total})
				3:
					current_track.back()["ending_beat"] = (note * bar_note_length) + beat_running_total
		
		beat_running_total += 4.0
	
	return {"difficulty" : chart_name, "track_1" : track_1, "track_2" : track_2, "track_3" : track_3}
