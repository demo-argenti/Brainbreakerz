extends Node2D

@onready var Spykez = $Spykez
@onready var Crash = $Crash
@onready var Grem = $Grem

var ZombieDie = preload("res://objects/zombie_die.tscn")
var ZombieFall = preload("res://objects/zombie_fall.tscn")

func _ready():
	Global.current_level = get_tree().current_scene.scene_file_path
	
	Global.out_of_lives.connect(_on_out_of_lives)
	
	$KeyListener.connect("Hit", SpykezZombieDie)
	$KeyListener2.connect("Hit", CrashZombieDie)
	$KeyListener3.connect("Hit", GremZombieDie)
	
	ZombieFall.connect("DieDone", SpykezZombieFall)
	ZombieFall.connect("DieDone", CrashZombieFall)
	ZombieFall.connect("DieDone", GremZombieFall)
	
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

func SpykezZombieDie():
	var instance = ZombieDie.instantiate()
	add_child(instance)
	instance.position = Vector2(30, 155)
	

func SpykezZombieFall():
	var instance = ZombieFall.instantiate()
	add_child(instance)
	instance.position = Vector2(30, 155)

func CrashZombieDie():
	var instance = ZombieDie.instantiate()
	add_child(instance)
	instance.position = Vector2(30, 322)

func CrashZombieFall():
	var instance = ZombieFall.instantiate()
	add_child(instance)
	instance.position = Vector2(30, 322)

func GremZombieDie():
	var instance = ZombieDie.instantiate()
	add_child(instance)
	instance.position = Vector2(30, 454)	

func GremZombieFall():
	var instance = ZombieFall.instantiate()
	add_child(instance)
	instance.position = Vector2(30, 454)

func _on_conductor_finished():
	get_tree().change_scene_to_file("res://objects/victory_screen.tscn")

func _on_out_of_lives():
	
	get_tree().change_scene_to_file("res://objects/loss_screen.tscn")
