class_name Calibration
extends Control
static var has_instance := false

var read_list : Array[float] = []
# TODO persist these
static var audio_latency : float = 0.0 # TODO allow manual adjust in settings
static var visual_latency_offset : float = 0.0 ## Relative to audio latency
static var has_done_calibration := false

func _ready() -> void:
	assert(!has_instance,"????????")
	has_instance = true
func _exit_tree() -> void:
	print(read_list)
	has_instance = false
	has_done_calibration = true
	audio_latency = max(0.0,audio_latency)
	# TODO include a message in the post-play dialogic if this happens
	# (it shouldn't, unless latency is super small and the player is hitting early)
	if audio_latency==0.0: pass


func _process(delta: float) -> void: pass


func _input(event: InputEvent) -> void:
	if !(event.is_action_pressed("middle_lane") and Conductor.playing): return
	
	var read : float = Conductor.seconds_to_beats(Conductor.song_position)
	if read < 0.0 or read > 33.0: return
	
	read = (read - roundf(read)) * (60.0 / Conductor.bpm)
	read_list.append(read)
	
	if read_list.size() >= 4:
		audio_latency = read_list.reduce(func(a,b)->float:return a+b) / read_list.size()
	
	queue_redraw()


func _draw() -> void:
	var tick_size := 12.0
	var x_scale := 1250.0
	var zero_position := Vector2(size.x/2.0, 0)
	
	draw_line(  zero_position + Vector2.UP * tick_size,
				zero_position + Vector2.DOWN * tick_size,
				Color(1.0,1.0,1.0,1.0 if read_list.size() < 4 else 0.5), 1.5,true )
	
	for read in read_list:
		draw_line(  zero_position + (Vector2.RIGHT * read * x_scale) + (Vector2.UP   * tick_size/2.0),
					zero_position + (Vector2.RIGHT * read * x_scale) + (Vector2.DOWN * tick_size/2.0),
					Color(0.8,1.0,1.0,0.4), 1,true )
	if read_list.size() >= 4:
		var avg := audio_latency
		draw_line(  zero_position + (Vector2.RIGHT * avg * x_scale) + Vector2.UP * tick_size,
					zero_position + (Vector2.RIGHT * avg * x_scale) + Vector2.DOWN * tick_size,
					Color(0.2,1.0,0.4,0.8), 1.5,true )
