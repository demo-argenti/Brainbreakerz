extends Node2D

@onready var input = preload("res://objects/inputs.tscn")
@export var lane_name: String = ""

@export var spawn_beat : int


var input_chart : Array

var input_queue : Array[BBKZInput] = []

const Lane = Global.Lane
const HitScore = Global.HitScore

# TODO replace these with one that has the duty for all judgments!
signal PerfectHit
signal GreatHit
signal GoodHit
signal MissHit

signal Hit


func _ready() -> void:
	$Arrow.frame = get_lane_sprite() - 4
	Global.song_time.connect(_on_song_time_emitted) # TODO away with this
	Global.note_chart_received.connect(_on_note_chart_received)
	$Perfect.visible = false
	$Great.visible = false
	$Good.visible = false
	$Miss.visible = false


func _physics_process(_delta: float) -> void:
	var song_pos := Conductor.song_position - Calibration.audio_latency
	if input_queue.size() > 0:
		if is_instance_valid(input_queue.front()):
			if song_pos > input_queue.front().landing_time + 0.1:
				if not input_queue.is_empty() and not input_queue.front().is_hit:
					input_queue.pop_front()
					$AnimationPlayer.play("miss_fade")
					Global.lose_life.emit()
					emit_signal("MissHit")
			if not input_queue.is_empty() and song_pos > input_queue.front().get_ending_time() + 0.1: # this input might not be in the tree?
				input_queue.pop_front().queue_free()
			
			if Input.is_action_just_pressed(lane_name):
				if not input_queue.is_empty():
					var hit = input_queue.front().calculate_hit(song_pos)
					if hit > 0:
						if not input_queue.front().is_held_note:
							input_queue.pop_front().queue_free()
						if !Calibration.has_instance:
							if hit == HitScore.PERFECT:
								# print ("Perfect!")
								$AnimationPlayer.play("perfect_fade")
								emit_signal("PerfectHit")
								emit_signal("Hit")
							if hit == HitScore.GREAT:
								$AnimationPlayer.play("great_fade")
								# print ("Great!")
								emit_signal("GreatHit")
								emit_signal("Hit")
							if hit == HitScore.GOOD:
								$AnimationPlayer.play("good_fade")
								# print ("Good!")
								emit_signal("GoodHit")
								emit_signal("Hit")
							Global.increment_score.emit(hit)
			if Input.is_action_pressed(lane_name):
				if not input_queue.is_empty():
					if input_queue.front().is_held_note and input_queue.front().is_in_duration():
						if input_queue.front().held_note_check():
							Global.increment_score.emit(4)
			else:
				if not input_queue.is_empty() and input_queue.front().is_held_note and input_queue.front().is_hit:
					input_queue.pop_front().queue_free()
			if Input.is_action_just_released(lane_name):
				# print("released:" + str(Global.current_song_position))
				if not input_queue.is_empty():
					if input_queue.front().is_held_note and song_pos > input_queue.front().landing_time + Conductor.quarter_length:
						var hit = input_queue.front().calculate_release(song_pos)
						input_queue.pop_front().queue_free()
						match hit:
							HitScore.PERFECT:
								$AnimationPlayer.play("perfect_fade")
								emit_signal("PerfectHit")
							HitScore.GREAT: $AnimationPlayer.play("great_fade")
							HitScore.GOOD:  $AnimationPlayer.play("good_fade")
							_: print(hit)
						Global.increment_score.emit(hit)
						# I think the problem lies in here somewhere. When I release the held notes immediately after hitting, it's a problem
						# Try adding something to make it so released held notes get deleted in a clean up move

# TODO just do this in process!
func _on_song_time_emitted(current_song_time) -> void:
	if !input_chart.is_empty():
		if current_song_time + Conductor.quarter_length * 6 \
				> input_chart.front().landing_beat * Conductor.quarter_length:
			spawn_input(input_chart.pop_front())

# returns an enum corresponding with the sprite arrow
func get_lane_sprite() -> int:
	match lane_name:
		"upper_lane": return Lane.UPPER
		"middle_lane": return Lane.MIDDLE
		"lower_lane": return Lane.LOWER
		_:
			assert(false)
			return 5 # unreachable


func _on_note_chart_received() -> void:
	match lane_name:
		# TODO we may need deep dupe for these if we upgrade note definitions to a class
		"upper_lane":  input_chart = Global.note_chart["track_1"].duplicate()
		"middle_lane": input_chart = Global.note_chart["track_2"].duplicate()
		"lower_lane":  input_chart = Global.note_chart["track_3"].duplicate()
		_: assert(false,"unreachable")


func spawn_input(note) -> void:
	var spawned_input = input.instantiate()
	get_tree().current_scene.call_deferred("add_child", spawned_input)
	if note.is_held_note:
		var duration = note.ending_beat - note.landing_beat
		spawned_input.setup(position, 6, get_lane_sprite(), lane_name, note.landing_beat, note.is_held_note, duration)
	else:
		spawned_input.setup(position, 6, get_lane_sprite(), lane_name, note.landing_beat, note.is_held_note, 0)
	
	input_queue.push_back(spawned_input)
