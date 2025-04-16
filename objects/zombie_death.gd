extends AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play("FallDown")

	
	connect("animation_finished", despawn)


func despawn():
	queue_free()
