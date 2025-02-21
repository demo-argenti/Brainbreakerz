extends Node

# song signals
signal song_beat(input)
signal bar_beat(input)
signal song_time(input)
signal measure(input)
signal delta_pos(input)

# score signal
signal increment_score(precision)

var current_song_position : float
var current_beat : int
var current_bar_beat : int
var current_measure : int
var current_song_delta : float

var quarter_length : float

var current_song_length : float

enum {PERFECT = 1, GREAT = 2, GOOD = 3, NOT_HIT = 0}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bar_beat.connect(_on_bar_beat_emmitted)
	song_beat.connect(_on_song_beat_emmitted)
	song_time.connect(_on_song_time_emmitted)
	measure.connect(_on_measure_emmitted)
	delta_pos.connect(_on_delta_pos_emmitted)

func _on_bar_beat_emmitted(input):
	current_bar_beat = input
	
func _on_song_beat_emmitted(input):
	current_beat = input
	
func _on_song_time_emmitted(input):
	current_song_position = input
	
func _on_measure_emmitted(input):
	current_measure = input
	
func _on_delta_pos_emmitted(input):
	current_song_delta = input
