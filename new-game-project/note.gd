extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var _animation_player = $AnimationPlayer
@onready var _hit_area = $HitArea

func _physics_process(delta: float) -> void:
	_animation_player.play("move_note_normal")
	if Input.is_action_just_pressed("ui_up") and _hit_area.overlaps_area($"../NoteChecker"):
		die()
	
func die():
	queue_free()
