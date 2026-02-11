extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = false
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event : InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_tree().paused = !get_tree().paused
