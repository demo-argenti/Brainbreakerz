extends Node2D

@onready var Spykez = $Spykez
@onready var Crash = $Crash
@onready var Grem = $Grem



func _ready():
	Global.out_of_lives.connect(_on_out_of_lives)
	
	Spykez.play("Play")
	Crash.play("Play")
	Grem.play("Play")
	
	$Spykez.connect("animation_finished", SpykezDone)
	$Crash.connect("animation_finished", CrashDone)
	$Grem.connect("animation_finished", GremDone)
	
	$KeyListener.connect("PerfectHit", SpykezPerfect)
	$KeyListener.connect("MissHit", SpykezMiss)
	
	$KeyListener2.connect("PerfectHit", CrashPerfect)
	$KeyListener2.connect("MissHit", CrashMiss)
	
	$KeyListener3.connect("PerfectHit", GremPerfect)
	$KeyListener3.connect("MissHit", GremMiss)

func SpykezPerfect():
	Spykez.play("Perfect")
func SpykezMiss():
	Spykez.play("Miss")
func SpykezDone():
	Spykez.play("Play")

func CrashPerfect():
	Crash.play("Perfect")
func CrashMiss():
	Crash.play("Miss")
func CrashDone():
	Crash.play("Play")
	
func GremPerfect():
	Grem.play("Perfect")
func GremMiss():
	Grem.play("Miss")
func GremDone():
	Grem.play("Play")

func _on_conductor_finished():
	get_tree().change_scene_to_file("res://objects/victory_screen.tscn")

func _on_out_of_lives():
	get_tree().change_scene_to_file("res://objects/loss_screen.tscn")
