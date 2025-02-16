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

var spawn_beat
var landing_beat

var spawn_time
var landing_time

func _init() -> void:
	set_process(false)

func setup(spawner_pos: Vector2, beat_speed_duration, lane_sprite):
	frame = lane_sprite
	global_position = Vector2(initial_x_position, spawner_pos.y)
	end_pos = spawner_pos
	distance_to_travel = position.x - end_pos.x
	beat_speed = beat_speed_duration
	_calculate_actual_distance()
	flight_duration = (beat_speed+1) * Global.quarter_length
	spawn_beat = Global.current_beat
	set_process(true)

func _calculate_actual_distance():
	actual_distance = (distance_to_travel/beat_speed) * (beat_speed+1)
	_actual_end_pos.x = position.x - actual_distance
	_actual_end_pos.y = position.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position.x -= (actual_distance/flight_duration) * Global.current_song_delta
	
	if position.x <= _actual_end_pos.x:
		_die()
	
func _die():
	queue_free()
	
