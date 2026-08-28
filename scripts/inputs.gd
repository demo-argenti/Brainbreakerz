class_name BBKZInput # TODO rename this!!
extends Sprite2D


var initial_x_position : float = 1216
var end_pos : Vector2
var _actual_end_pos : Vector2
var distance_to_travel
var actual_distance : float

var beat_speed : int
var flight_duration : float

var spawn_beat : float
var landing_beat : float

var spawn_time : float
var landing_time : float

#the distance in pixels a note travels in a beat
var beat_distance : float 

var lane_name : String

#var has_passed : bool

# true if note hit successfully
var is_hit : bool

var initial_position : Vector2

# handles held notes
var is_held_note : bool
var duration : float
var held_time_tick : float

const PERFECT_RANGE = 0.024
const GREAT_RANGE = 0.08
const GOOD_RANGE = 0.16

const HitScore = Global.HitScore


func _init() -> void: set_process(false)


func setup(spawner_pos: Vector2, beat_speed_duration, lane_sprite, lane:String, spawn_beat:float, is_held_note:bool, duration:float):
	frame = lane_sprite
	global_position = Vector2(initial_x_position, spawner_pos.y)
	end_pos = spawner_pos
	distance_to_travel = position.x - end_pos.x
	beat_speed = beat_speed_duration
	_calculate_actual_distance()
	
	flight_duration = (beat_speed+1) * Global.quarter_length
	
	beat_distance = distance_to_travel/beat_speed
	
	landing_beat = spawn_beat
	landing_time = Conductor.beats_to_seconds(landing_beat) # before ready lol
	
	self.is_held_note = is_held_note
	self.duration = duration
	
	if is_held_note:
		$Tail.points[1].x = beat_distance * (duration)
		held_time_tick = landing_time + Global.quarter_length / 2
		
	is_hit = false
	
	#lane_name = lane
	#has_passed = false
	
	set_process(true)


# Judgement logic
func calculate_hit(hit_time:float) -> int:
	print("%f......%f" % [hit_time - landing_time, Calibration.audio_latency])
	pass
	if _within_range(hit_time, landing_time, PERFECT_RANGE):
		is_hit = true
		return HitScore.PERFECT
	elif _within_range(hit_time, landing_time, GREAT_RANGE):
		is_hit = true
		return HitScore.GREAT
	elif _within_range(hit_time, landing_time, GOOD_RANGE):
		is_hit = true
		return HitScore.GOOD
	return HitScore.NOT_HIT

func calculate_release(hit_time:float) -> int:
	if is_hit:
		if _within_range(hit_time, landing_time + (duration * Global.quarter_length), PERFECT_RANGE):
			return HitScore.PERFECT
		elif _within_range(hit_time, landing_time + (duration * Global.quarter_length), GREAT_RANGE):
			return HitScore.GREAT
		elif _within_range(hit_time, landing_time + (duration * Global.quarter_length), GOOD_RANGE):
			return HitScore.GOOD
		is_hit = false
		return HitScore.NOT_HIT
	return HitScore.NOT_HIT
	
func is_in_duration() -> bool:
	return Global.current_song_position < landing_time + (duration * Global.quarter_length) and Global.current_song_position > landing_time

# evaluates whether a given value is within plus or minus a range of a given target value
func _within_range(value, target, range):
	return (value <= target + range and value >= target - range)


func get_ending_time() -> float:
	return landing_time + (duration if is_held_note else 0) * Conductor.quarter_length


#calculates the actual distance the note needs to travel to hit the target on time while traveling off screen
func _calculate_actual_distance() -> void:
	actual_distance = (distance_to_travel/beat_speed) * (beat_speed+1)
	_actual_end_pos.x = position.x - actual_distance
	_actual_end_pos.y = position.y


func _physics_process(_delta: float) -> void:
	# note to self: consider that EVERY input is calculating this --
	# it's only a bit of simple math but maybe let Conductor do that once
	# (before anything else gets processed on that frame) and expose it!
	var beats_til = landing_beat - Conductor.seconds_to_beats(Conductor.song_position - Calibration.audio_latency)
	var target_x = end_pos.x + (beats_til * 300.0)
	
	# TODO: if we implement soflan stuff we'll need to rethink pos calculation
	if abs(position.x - target_x) < 10.0: position.x = target_x
	else: # for calib, quickly but smoothly move on retime
		position.x += (target_x - position.x) / 3.0
	
#	if position.x < end_pos.x:
#		has_passed = true
	
	if Conductor.song_position > landing_time + (duration * Conductor.quarter_length) + Conductor.quarter_length:
		if is_held_note:
			pass
		queue_free()


func held_note_check() -> bool:
	var time = Global.current_song_position
	if time > landing_time and time < get_ending_time() and is_hit:
		if time > held_time_tick:
			held_time_tick += Global.quarter_length/2
			return true
	return false


# distance = speed / time, therefore I need the beat speed in order to calculate note trail lengths

# if we need to handle pre-free tasks we can do it in _exit_tree()
#func _die() -> void: queue_free()
