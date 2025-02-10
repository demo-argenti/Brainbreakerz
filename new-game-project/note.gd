extends CharacterBody2D

@onready var _animation_player = $AnimationPlayer
@onready var _hit_area = $HitArea
@export  var input_key: String

func _physics_process(delta: float) -> void:
	_animation_player.play("move_note_normal")
	if Input.is_action_just_pressed(input_key) and _hit_area.overlaps_area($"../NoteChecker"):
		die()
	
func die():
	queue_free()
