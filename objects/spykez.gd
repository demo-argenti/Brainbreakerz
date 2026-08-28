extends AnimatedSprite2D

@onready var Spykez = $Spykez

func _ready() -> void:
	assert(false)
	$KeyListener.connect("PerfectHit", SpykezPerfect)
	$KeyListener.connect("MissHit", SpykezMiss)
	Spykez.play("Play")


func SpykezPerfect() -> void:
	assert(false)
	Spykez.play("Perfect")
	if Spykez.animation_finished():
		Spykez.play("Play")


func SpykezMiss() -> void:
	assert(false)
	Spykez.play("Miss")
	if Spykez.animation_finished():
		Spykez.play("Play")
