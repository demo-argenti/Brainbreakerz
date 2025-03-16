extends Sprite2D

@onready var input = preload("res://objects/inputs.tscn")
@export var lane_name: String = ""

@export var spawn_beat : int

enum {UPPER_LANE = 4, MIDDLE_LANE = 6, LOWER_LANE = 7}

var input_chart : Array

var input_queue : Array = [];

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.song_time.connect(_on_song_time_emmitted)
	Global.note_chart_received.connect(_on_note_chart_received)
	$Perfect.visible = false
	$Great.visible = false
	$Good.visible = false
	$Miss.visible = false

# Called every time step. 'delta' is the elapsed time since the previous time step.
func _physics_process(delta: float) -> void:
	if input_queue.size() > 0:
		if is_instance_valid(input_queue.front()):
			if Global.current_song_position > input_queue.front().landing_time + 0.4:
				input_queue.pop_front()
				$AnimationPlayer.play("miss_fade")
			
			if Input.is_action_just_pressed(lane_name):		
				var hit = input_queue.front().calculate_hit(Global.current_song_position)
				if hit > 0:
					input_queue.pop_front()._die()
					if hit == Global.PERFECT:
						# print ("Perfect!")
						$AnimationPlayer.play("perfect_fade")
					if hit == Global.GREAT:
						$AnimationPlayer.play("great_fade")
						# print ("Great!")
					if hit == Global.GOOD:
						$AnimationPlayer.play("good_fade")
						# print ("Good!")
					Global.increment_score.emit(hit)	
				
		
		
		
func _on_song_time_emmitted(current_song_time):
	if !input_chart.is_empty() and current_song_time + Global.quarter_length * 4 > input_chart.front().landing_beat * Global.quarter_length:
		spawn_input(input_chart.pop_front())

# returns an enum corresponding with the sprite arrow
func get_lane_sprite():
	if lane_name == "upper_lane":
		return UPPER_LANE
	elif lane_name == "middle_lane":
		return MIDDLE_LANE
	elif lane_name == "lower_lane":
		return LOWER_LANE
	else:
		return 5
		
func _on_note_chart_received():
	if lane_name == "upper_lane":
		input_chart = Global.note_chart.front().track_1.duplicate()
	elif lane_name == "middle_lane":
		input_chart = Global.note_chart.front().track_2.duplicate()
	elif lane_name == "lower_lane":
		input_chart = Global.note_chart.front().track_3.duplicate()
	else:
		pass

# spawns an input note and adds it to the input_queue
func spawn_input(note):
	var spawned_input = input.instantiate()
	get_tree().current_scene.call_deferred("add_child", spawned_input)
	if note.is_held_note:
		var duration = note.ending_beat - note.landing_beat
		spawned_input.setup(position, 4, get_lane_sprite(), lane_name, note.landing_beat, note.is_held_note, duration)
	else:
		spawned_input.setup(position, 4, get_lane_sprite(), lane_name, note.landing_beat, note.is_held_note, 0)
	
	input_queue.push_back(spawned_input)
