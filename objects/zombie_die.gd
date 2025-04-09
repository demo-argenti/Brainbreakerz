extends AnimatedSprite2D

signal DieDone

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play("Die")
	
	emit_signal("DieDone")
