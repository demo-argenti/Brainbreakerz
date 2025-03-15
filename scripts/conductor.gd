extends AudioStreamPlayer


@onready var beats_per_bar : int = stream.get_bar_beats()
@onready var bpm : float = stream.get_bpm()
@onready var beat_count : int = stream.get_beat_count() #length of song in beats
@onready var quarter_length : float = 60.0/stream.get_bpm() #length of quarter note in seconds
@onready var song_measures : int = beat_count/beats_per_bar
@onready var start_timer = $StartTimer

@onready var last_song_beat : float = 0

@export var chart_name : String

var time_start
var time_current

# song position variables
var song_position : float = 0 # current position in song in seconds
var previous_song_pos : float = 0
var delta_song_pos : float = 0

# song beat variables
var current_song_beat : int = 0
var current_bar_beat : int = 0

var current_song_measure : int = 0

var start_offset : float = 1.0

var note_reader : SM_Reader = SM_Reader.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	note_reader.filename = chart_name
	note_reader.set_file()
	note_reader.read_file()
	
	self.stream = load(NodePath("res://sounds/music/" + note_reader.song_file))
	
	bpm = note_reader.bpms[0].bpm
	beat_count = stream.get_beat_count()
	start_offset = note_reader.offset
	quarter_length = 60.0/bpm
	beats_per_bar = stream.get_bar_beats()
	song_measures = beat_count/beats_per_bar
	
	Global.note_chart = note_reader.charts
	Global.note_chart_received.emit()
	Global.quarter_length = quarter_length
	Global.current_song_length = stream.get_length()
	play_with_offset()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if playing:
		song_position = get_playback_position() + AudioServer.get_time_since_last_mix()
		# Compensate for output latency.
		song_position -= AudioServer.get_output_latency()
		
		delta_song_pos = song_position - previous_song_pos
		previous_song_pos = song_position
		
		Global.song_time.emit(song_position)
		Global.delta_pos.emit(delta_song_pos)
		
		if song_position > (last_song_beat + quarter_length):
			current_song_beat = int(floor(song_position/quarter_length))
			Global.song_beat.emit(current_song_beat)
			
			current_bar_beat = current_song_beat % 4
			Global.bar_beat.emit(current_bar_beat)
			
			current_song_measure = current_song_beat/4
			Global.measure.emit(current_song_measure)
			
			last_song_beat += quarter_length
			# print(current_song_beat, "  ", current_bar_beat)



func play_with_offset():
	play(0 - start_offset)
	

func play_from_beat(beat, offset):
	play()
	seek(beat * quarter_length - start_offset)

	
	current_bar_beat = (beat % beats_per_bar)
	if current_bar_beat == 0:
		current_bar_beat = beats_per_bar
	

func _on_start_timer_timeout() -> void:
	play()	
	song_position = get_playback_position() + AudioServer.get_time_since_last_mix()
	# Compensate for output latency.
	song_position -= AudioServer.get_output_latency()
	
	Global.song_time.emit(song_position)
	Global.song_beat.emit(current_song_beat)
	Global.bar_beat.emit(current_bar_beat)
	Global.measure.emit(current_song_measure)
	start_timer.stop()
