extends Sprite2D

@export var conductor_path : NodePath
@onready var conductor = conductor_path


var initial_x_position: float = 1216
var end_pos : Vector2
var _actual_end_pos : Vector2
var distance_to_travel
var actual_distance : float

var beat_speed : int
var flight_duration : float

var spawn_beat : int
var landing_beat : int

var spawn_time : float
var landing_time : float

var lane_name : String

var has_passed : bool

const PERFECT_RANGE = 0.025
const GREAT_RANGE = 0.038
const GOOD_RANGE = 0.5

enum {PERFECT = 1, GREAT = 2, GOOD = 3, NOT_HIT = 0}

func _init() -> void:
	set_process(false)

func setup(spawner_pos: Vector2, beat_speed_duration, lane_sprite, lane: String):
	frame = lane_sprite
	global_position = Vector2(initial_x_position, spawner_pos.y)
	end_pos = spawner_pos
	distance_to_travel = position.x - end_pos.x
	beat_speed = beat_speed_duration
	_calculate_actual_distance()
	
	flight_duration = (beat_speed+1) * Global.quarter_length
	
	spawn_beat = Global.current_beat
	spawn_time = Global.current_song_position
	
	landing_beat = spawn_beat + beat_speed
	landing_time = spawn_time + (beat_speed * Global.quarter_length)
	
	lane_name = lane
	
	has_passed = false
	set_process(true)


func calculate_hit(hit_time) -> int:
	if _within_range(hit_time, landing_time, PERFECT_RANGE):
		return Global.PERFECT
	elif _within_range(hit_time, landing_time, GREAT_RANGE):
		return Global.GREAT
	elif _within_range(hit_time, landing_time, GOOD_RANGE):
		return Global.GOOD
	return NOT_HIT
	
# evaluates whether a given value is within plus or minus a range of a given target value
func _within_range(value, target, range):
	if value <= target + range and value >= target - range:
		return true
	return false

#calculates the actual distance the note needs to travel to hit the target on time while traveling off screen
func _calculate_actual_distance():
	actual_distance = (distance_to_travel/beat_speed) * (beat_speed+1)
	_actual_end_pos.x = position.x - actual_distance
	_actual_end_pos.y = position.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position.x -= (actual_distance/flight_duration) * Global.current_song_delta
	
#	if position.x < end_pos.x:
#		has_passed = true
	
	if position.x <= _actual_end_pos.x:
		_die()


# destroys input note
func _die():
	queue_free()
	
