extends Sprite2D

@onready var input = preload("res://inputs.tscn")
@export var lane_name: String = ""

@export var spawn_beat : int

enum {UPPER_LANE = 4, MIDDLE_LANE = 6, LOWER_LANE = 7}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.bar_beat.connect(_on_bar_beat_emmitted)

# Called every time step. 'delta' is the elapsed time since the previous time step.
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed(lane_name):
		print(lane_name, " just pressed")
		
func _on_bar_beat_emmitted(current_bar_beat):
	if current_bar_beat == spawn_beat:
		spawn_input()

func get_lane_sprite():
	if lane_name == "upper_lane":
		return UPPER_LANE
	elif lane_name == "middle_lane":
		return MIDDLE_LANE
	elif lane_name == "lower_lane":
		return LOWER_LANE
	else:
		return 5

func spawn_input():
	var spawned_input = input.instantiate()
	get_tree().get_root().call_deferred("add_child", spawned_input)
	spawned_input.setup(position, 8, get_lane_sprite())
