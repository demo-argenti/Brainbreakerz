extends Node

@onready var stream_start_timer : Timer = $StreamStartTimer

@onready var Three = $Three
@onready var Two = $Two
@onready var One = $One
@onready var Go = $Go

@onready var count : int = -2_147_483_648

const END_BEAT : int = 8

var wait_time : float = 1.0

signal stream_delay_over


func _ready():
	stream_start_timer.timeout.connect(func()->void: stream_delay_over.emit())


func _process(_delta):
	var song_pos = Conductor.precise_song_pos(true)
	if song_pos >= 0: return
	if is_nan(song_pos): return
	if count==-2_147_483_648: count = floor(song_pos)
	
	if floor(song_pos) > count: count += 1
	else: return
	
	match count:
		-4: Three.play()
		-3: Two.play()
		-2: One.play()
		-1: Go.play()


func reset_count() -> void: count = -2_147_483_648

func start_from(time:float): stream_start_timer.start(abs(time))


func time_till_stream_start() -> float:
	if !stream_start_timer.is_stopped(): return stream_start_timer.time_left
	return NAN
