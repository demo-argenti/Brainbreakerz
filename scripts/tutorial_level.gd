extends Node2D

@onready var Spykez = $Spykez
@onready var Crash = $Crash
@onready var Grem = $Grem

@export_enum("tutorial", "level_1", "level_2", "level_3") var level: int


func _ready():
	Global.current_level = get_tree().current_scene.scene_file_path
	
	Global.out_of_lives.connect(_on_out_of_lives)
	
	Global.is_high_score = false
	Global.high_score = 0
	
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
	if (SaveLoad.get_current_level_high_score(level) < Global.level_score):
		Global.is_high_score = true
		SaveLoad.save_current_level_high_score(level, Global.level_score)
	Global.high_score = SaveLoad.get_current_level_high_score(level)
	get_tree().change_scene_to_file("res://objects/victory_screen.tscn")

func _on_out_of_lives():
	
	get_tree().change_scene_to_file("res://objects/loss_screen.tscn")
