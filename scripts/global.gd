extends Node


# song signals
#signal song_beat(input)
#signal bar_beat(input)
#signal measure(input)
signal delta_pos(input)
signal song_time(input)
signal note_chart_received()
signal out_of_lives()

# score signal
signal increment_score(precision:HitScore)

# life system
signal increment_life()
signal lose_life()


var game_folder : String

#var note_chart : Array
var note_chart : Dictionary

var current_song_position : float
var current_beat : float
var current_bar_beat : float
var current_measure : int
var current_song_delta : float

var quarter_length : float:
	get:
		# this is probably fine...
		#push_warning("get quarter length from Conductor instead thanks!")
		#print_stack()
		return Conductor.quarter_length

#var current_song_length : float

var level_score : int
var level_lives : int

# TODO obsolete!
var current_level:
	set(value):
		current_level = value
		match value:
			tutorial: Conductor.load_chart("Warmin' Up")
			level_1:  Conductor.load_chart("level_1")
			level_2:  Conductor.load_chart("level_2")
			level_3:  Conductor.load_chart("Deadlock")
			bonus_level: Conductor.load_chart("Yatatatata")
#var is_high_score = false
var high_score : int
var fps := 60.0


# TODO should this stuff belong to conductor???
var current_song : SongDef:
	set(v): current_song = v
var current_chart_idx : int:
	set(v):
		if v==-1:
			current_chart_idx = v
			return
		assert(v in range(current_song.charts.size()))
		current_chart_idx = v
		current_chart = current_song.charts[v]
		#note_chart = [ current_chart.notes["track_1"],
						#current_chart.notes["track_2"],
						#current_chart.notes["track_3"], ]
		note_chart = current_chart.notes
		note_chart_received.emit()
var current_chart : ChartDef

var queued_song: SongDef
var queued_chart_idx: int #ChartDef

func _pop_queue() -> void:
	assert(queued_song  != null, "tried to swap in chart but nothing enqueued!")
	assert(queued_chart_idx != -1, "tried to swap in chart but nothing enqueued!")
	current_song = queued_song
	current_chart_idx = queued_chart_idx
	queued_song = null
	queued_chart_idx = -1

enum Lane { UPPER = 4, MIDDLE = 6, LOWER = 7 }
# TODO? move this into a judgement/scoring class of its own
enum HitScore { PERFECT = 1, GREAT = 2, GOOD = 3, HOLD_TICK = 4, NOT_HIT = 0 }

enum { tutorial = 0, level_1 = 1, level_2 = 2, level_3 = 3, bonus_level = 4 }


func _ready() -> void:
	#bar_beat.connect(_on_bar_beat_emitted)
	#song_beat.connect(_on_song_beat_emitted)
	#song_time.connect(_on_song_time_emitted)
	#measure.connect(_on_measure_emitted)
	delta_pos.connect(_on_delta_pos_emitted)
	
	
	var temp = OS.get_executable_path().split("/")
	temp.resize(temp.size() - 1)
	game_folder = "/".join(temp)
	
	if OS.is_debug_build():
		add_child(preload("uid://du4nqyeckbhqi").instantiate())
	
	Prefs.setup()

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_WM_CLOSE_REQUEST:
			print("awoo")
			Prefs.save()


func set_chart(song:SongDef,idx:int) -> void:
	current_song = song
	current_chart_idx = idx


func _process(__: float) -> void:
	fps = DisplayServer.screen_get_refresh_rate(get_window().current_screen)
	#if Input.is_key_label_pressed(KEY_A): print("glob: stream pos: %.3f (2)" % Conductor.precise_stream_pos())

#func _on_bar_beat_emitted(input):
	#print("beat %s" % [input])
	#current_bar_beat = input

#func _on_song_beat_emitted(input): current_beat = input
#func _on_song_time_emitted(input): current_song_position = input
#func _on_measure_emitted(input):   current_measure = input
func _on_delta_pos_emitted(input): current_song_delta = input
