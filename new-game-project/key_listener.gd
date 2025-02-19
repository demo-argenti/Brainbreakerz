extends Sprite2D

@onready var input = preload("res://inputs.tscn")
@export var lane_name: String = ""

@export var spawn_beat : int

enum {UPPER_LANE = 4, MIDDLE_LANE = 6, LOWER_LANE = 7}

var input_queue : Array = [];

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.bar_beat.connect(_on_bar_beat_emmitted)
	$Perfect.visible = false
	$Great.visible = false
	$Good.visible = false
	$Miss.visible = false

# Called every time step. 'delta' is the elapsed time since the previous time step.
func _physics_process(delta: float) -> void:
	if input_queue.size() > 0:
		if Global.current_song_position> input_queue.front().landing_time + 0.4:
			input_queue.pop_front()
			$AnimationPlayer.play("miss_fade")
			
		if Input.is_action_just_pressed(lane_name):		
			var hit = input_queue.front().calculate_hit(Global.current_song_position)
			if hit > 0:
				input_queue.pop_front()._die()
				if hit == Global.PERFECT:
					print ("Perfect!")
					$AnimationPlayer.play("perfect_fade")
				if hit == Global.GREAT:
					$AnimationPlayer.play("great_fade")
					print ("Great!")
				if hit == Global.GOOD:
					$AnimationPlayer.play("good_fade")
					print ("Good!")
				Global.increment_score.emit(hit)	
				
		
		
		
# spawns an input note on the spawn beat
func _on_bar_beat_emmitted(current_bar_beat):
	if current_bar_beat == spawn_beat:
		spawn_input()

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

# spawns an input note and adds it to the input_queue
func spawn_input():
	var spawned_input = input.instantiate()
	get_tree().get_root().call_deferred("add_child", spawned_input)
	spawned_input.setup(position, 8, get_lane_sprite(), lane_name)
	
	input_queue.push_back(spawned_input)
