extends Node2D

@onready var music: AudioStreamPlayer2D = $Music

func play_music():
	if music.playing == false:
		
		music.play()


func pause_music():
	music.stop()


#keeping these just in case i want to use these

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
