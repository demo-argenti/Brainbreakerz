extends AnimatedSprite2D

@onready var Spykez = $Spykez

func _ready() -> void:
	$KeyListener.connect("PerfectHit", SpykezPerfect)
	$KeyListener.connect("MissHit", SpykezMiss)
	Spykez.play("Play")
	
func SpykezPerfect() -> void:
	Spykez.play("Perfect")
	if Spykez.animation_finished():
		Spykez.play("Play")
		

func SpykezMiss() -> void:
	Spykez.play("Miss")
	if Spykez.animation_finished():
		Spykez.play("Play")
