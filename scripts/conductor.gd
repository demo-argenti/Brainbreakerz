extends AudioStreamPlayer

# TODO especially for when we implement user charts: instead of relying on the stream
# and trying to put these in there when a chart is saved,
# put them in the song resource and access from there
# (not all formats have these anyway though using WAVs should be discouraged)
#var beats_per_bar : int:
	#get:
		#if stream.has_method("get_bar_beats"): return stream.get_bar_beats()
		#return 4 # safe bet
var bpm : float
	#get: return stream.get_bpm()
#var beat_count : int:
	#get:
		#if stream.has_method("get_bar_beats"):
			#return stream.get_beat_count() # length of song in beats
		#return -1
var quarter_length : float:
	get: return 60.0 / bpm # length of quarter note in seconds
#var song_measures : int:
	#get: return beat_count / beats_per_bar

@onready var countdown_timer = $CountDownTimer

@onready var last_song_beat : float = 0

# song position variables
var song_position     := 0.0 # in seconds
var _previous_song_pos := 0.0 ## WARNING not to be accessed from outside! use delta_song_pos!
var delta_song_pos    := 0.0

# song beat variables
var current_song_beat : int = 0
var current_bar_beat : int = 0
var current_song_measure : int = 0

# TODO move this into the song resource
var first_beat_offset : float = 0.0
var note_reader : SM_Reader = SM_Reader.new()


func _ready() -> void:
	countdown_timer.stream_delay_over.connect(func()->void: play())
	finished.connect(_on_finished)

## in seconds since start of the stream.
## putting this logic into its own function so everyone can access it.
## WARNING this can return NAN if neither playing nor counting down! be sure to guard against this!
func precise_stream_pos() -> float:
	if !playing: return -(countdown_timer.time_till_stream_start())
	var true_playback_position = get_playback_position()\
			+ AudioServer.get_time_since_last_mix() - AudioServer.get_output_latency()
	return true_playback_position
## given in seconds or beats relative to the first beat of the song.
## WARNING this returns NAN under the same conditions as precise_stream_pos()!
func precise_song_pos(in_beats:=false) -> float:
	var pos_in_stream := precise_stream_pos()
	return NAN if is_nan(pos_in_stream) else ( (pos_in_stream - first_beat_offset)
											* ((bpm / 60.0) if in_beats else 1.0) )

# TODO are these confusing? make separate functions for positions and durations?
## in is relative to first beat. out is relative to stream start.
func beats_to_seconds(beats:float) -> float:
	return (beats * (60.0 / bpm)) + first_beat_offset
## in is relative to stream start. out is relative to first beat.
func seconds_to_beats(seconds:float) -> float:
	return (seconds - first_beat_offset) * (bpm / 60.0)


func load_chartdef(song:SongDef,idx:int) -> void:
	Global.set_chart(song,idx)
	bpm = song.bpm
	#quarter_length = 60.0 / bpm
	first_beat_offset = song.first_beat_offset
	
	self.stream = load(song.audio_file)
	
	# JK handled by global!
	#Global.note_chart = [ Global.current_chart.notes
							#]
	#Global.note_chart_received.emit()

## DEPRECATED
func load_chart(chart_name:String) -> void:
	note_reader.filename = chart_name
	note_reader.set_file()
	note_reader.read_file()
	#countdown_timer.countdown_finished.connect(_on_countdown_finished)
	
	print("try to load in " + chart_name)
	self.stream = load(NodePath("res://sounds/music/" + note_reader.song_file))
	
	bpm = note_reader.bpms[0].bpm
	#beat_count = stream.get_beat_count()
	first_beat_offset = note_reader.offset
	#quarter_length = 60.0/bpm
	#beats_per_bar = stream.get_bar_beats()
	#song_measures = beat_count/beats_per_bar
	
	#countdown_timer.wait_time = quarter_length
	
	#Global.note_chart = note_reader.charts
	#Global.note_chart_received.emit()
	#Global.quarter_length = quarter_length
	#Global.current_song_length = stream.get_length()


func _physics_process(delta: float) -> void:
	if !playing: return
	
	song_position = precise_stream_pos()
	
	delta_song_pos = song_position - _previous_song_pos
	_previous_song_pos = song_position
	
	Global.song_time.emit(song_position)
	
	if song_position > (last_song_beat + quarter_length):
		current_song_beat = int(floor((song_position - first_beat_offset)/quarter_length))
		#Global.song_beat.emit(current_song_beat)
		
		current_bar_beat = current_song_beat % 4
		#Global.bar_beat.emit(current_bar_beat)
		
		current_song_measure = current_song_beat/4
		#Global.measure.emit(current_song_measure)
		
		last_song_beat += quarter_length
		# print(current_song_beat, "  ", current_bar_beat)
	if Input.is_key_label_pressed(KEY_A): print("cond: stream pos: %.3f (2)"%precise_stream_pos())

# we can use this later with params to start from an arbitrary point within the stream for editing
func begin_playback(count_in:float=true,from:float=NAN) -> void:
	assert(from != INF and from != -INF)
	
	if !is_nan(from):
		assert(from >= 0.0)
		play(from)
		return
	
	if !count_in:
		play()
		return
	
	var start_time := minf(beats_to_seconds(-8.0),0.0)
	if start_time == 0.0: play()
	else:
		#print("start %0.3fs ... %.3f" % [ start_time, seconds_to_beats(start_time) ])
		countdown_timer.start_from(start_time)


#func play_with_offset()  -> void: play(0 + first_beat_offset)


#func play_from_time(time : float) -> void:
	#play()
	#seek(time)
	#
	#current_bar_beat = (int((time - first_beat_offset)/quarter_length) % beats_per_bar)
	#if current_bar_beat == 0: current_bar_beat = beats_per_bar


#func play_from_beat(beat: int)  -> void:
	#play()
	#seek(beat * quarter_length + first_beat_offset)
	#
	#current_bar_beat = (beat % beats_per_bar)
	#if current_bar_beat == 0: current_bar_beat = beats_per_bar


#func count_in():
	#countdown_timer.wait_time = quarter_length
	#countdown_timer.start()


func fade_and_stop(time:float) -> void:
	var tween = create_tween()
	tween.tween_property(self,"volume_linear",0.0,time)
	await tween.finished
	stop()
	volume_linear = 1.0 # TODO use user-set value here
	song_position = 0.0
	countdown_timer.reset_count()

func _on_finished() -> void: countdown_timer.reset_count()


#func _on_countdown_finished() -> void:
	#print("timer done!")
	#print(song_position)
	#play_from_time(song_position)
	#song_position = precise_stream_pos()
	#
	#Global.song_time.emit(song_position)
	#Global.song_beat.emit(current_song_beat)
	#Global.bar_beat.emit(current_bar_beat)
	#Global.measure.emit(current_song_measure)
