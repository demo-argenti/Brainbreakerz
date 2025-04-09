extends AnimatedSprite2D

signal FallDone

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play("Fall")
	
	emit_signal("FallDone")
