extends Node

@onready var BeatTimer = $BeatTimer

@onready var Three = $Three
@onready var Two = $Two
@onready var One = $One
@onready var Go = $Go

@onready var count : int = 0
const END_BEAT : int = 8

var wait_time : float = 1.0

signal timer_finished


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	pass

# starts the countdown
func start():
	count = 0
	BeatTimer.wait_time = wait_time
	BeatTimer.start()
	

func _on_beat_timer_timeout():
	count += 1
	print(count)
	if(count < END_BEAT):
		BeatTimer.start()
	else:
		emit_signal("timer_finished")
		BeatTimer.stop()
		
	match count:
		5:
			Three.play()
		6:
			Two.play()
		7:
			One.play()
		8:
			Go.play()
	
