extends Node2D

@onready var Spykez = $Spykez
@onready var Crash = $Crash
@onready var Grem = $Grem


var ZombieDie = preload("res://objects/zombie_die.tscn")
var ZombieFall = preload("res://objects/zombie_fall.tscn")

#Feedback isnt working yet so func's that use it are commented out
var Feedback = preload("res://objects/Feedback.tscn")
var ZombieDeath = preload("res://objects/zombie_death.tscn")
@export_enum("tutorial", "level_1", "level_2", "level_3") var level: int


func _ready() -> void:
	Global.current_level = get_tree().current_scene.scene_file_path
	
	Global.out_of_lives.connect(_on_out_of_lives)
	

	$KeyListener.connect("Hit", SpykezZombieDie)
	$KeyListener2.connect("Hit", CrashZombieDie)
	$KeyListener3.connect("Hit", GremZombieDie)
	ZombieDeath.connect("Done", Remove)
	Global.is_high_score = false
	Global.high_score = 0
	
	Spykez.play("Play")
	Crash.play("Play")
	Grem.play("Play")
	
	$Spykez.connect("animation_finished", SpykezDone)
	$Crash.connect("animation_finished", CrashDone)
	$Grem.connect("animation_finished", GremDone)
	
	$KeyListener.connect("PerfectHit", SpykezPerfect)
	$KeyListener.connect("GreatHit", SpykezGreat)
	$KeyListener.connect("GoodHit", SpykezGreat)
	$KeyListener.connect("MissHit", SpykezMiss)
	
	$KeyListener2.connect("PerfectHit", CrashPerfect)
	$KeyListener2.connect("GoodHit", CrashGreat)
	$KeyListener2.connect("MissHit", CrashGood)
	$KeyListener2.connect("MissHit", CrashMiss)
	
	$KeyListener3.connect("PerfectHit", GremPerfect)
	$KeyListener3.connect("GoodHit", GremGreat)
	$KeyListener3.connect("MissHit", GremGood)
	$KeyListener3.connect("MissHit", GremMiss)
	

	#$Transition.fade_in()

func SpykezPerfect() -> void:
	#var instance = Feedback.instantiate()
	#add_child(instance)
	#instance.position = Vector2(50, 230)
	Spykez.play("Perfect")
	$PerfectSplat.play()
func SpykezGreat() -> void:
	#var instance = Feedback.instantiate()
	#add_child(instance)
	#instance.position = Vector2(50, 230)
	pass
func SpykezGood() -> void:
	#var instance = Feedback.instantiate()
	#add_child(instance)
	#instance.position = Vector2(50, 230)
	pass
func SpykezMiss() -> void:
	#var instance = Feedback.instantiate()
	#add_child(instance)
	#instance.position = Vector2(50, 230)
	Spykez.play("Miss")
	$MissScratch.play()
func SpykezDone() -> void:
	Spykez.play("Play")

func CrashPerfect() -> void:
	Crash.play("Perfect")
	#var instance = Feedback.instantiate()
	#add_child(instance)
	#instance.position = Vector2(50, 360)
	$PerfectSplat.play()
func CrashGreat() -> void:
	#var instance = Feedback.instantiate()
	#add_child(instance)
	#instance.position = Vector2(50, 360)
	pass
func CrashGood() -> void:
	#var instance = Feedback.instantiate()
	#add_child(instance)
	#instance.position = Vector2(50, 360)
	pass
func CrashMiss() -> void:
	Crash.play("Miss")
	#var instance = Feedback.instantiate()
	#add_child(instance)
	#instance.position = Vector2(50, 360)
	$MissScratch.play()
func CrashDone() -> void:
	Crash.play("Play")
	
func GremPerfect() -> void:
	Grem.play("Perfect")
	#var instance = ZombieDeath.instantiate()
	#add_child(instance)
	#instance.position = Vector2(50, 490)
	$PerfectSplat.play()
func GremGreat() -> void:
	#var instance = ZombieDeath.instantiate()
	#add_child(instance)
	#instance.position = Vector2(50, 490)
	pass
func GremGood() -> void:
	#var instance = ZombieDeath.instantiate()
	#add_child(instance)
	#instance.position = Vector2(50, 490)
	pass
func GremMiss() -> void:
	Grem.play("Miss")
	#var instance = ZombieDeath.instantiate()
	#add_child(instance)
	#instance.position = Vector2(50, 490)
	$MissScratch.play()
func GremDone() -> void:
	Grem.play("Play")

func SpykezZombieDie() -> void:
	var instance = ZombieDeath.instantiate()
	add_child(instance)
	instance.position = Vector2(50, 230)
	$HitSplat.play()

func CrashZombieDie() -> void:
	var instance = ZombieDeath.instantiate()
	add_child(instance)
	instance.position = Vector2(50, 360)
	$HitSplat.play()

func GremZombieDie() -> void:
	var instance = ZombieDeath.instantiate()
	add_child(instance)
	instance.position = Vector2(50, 490)
	$HitSplat.play()

func Remove() -> void:
	ZombieDeath.queue_free()

func _on_conductor_finished() -> void:
	if (SaveLoad.get_current_level_high_score(level) < Global.level_score):
		Global.is_high_score = true
		SaveLoad.save_current_level_high_score(level, Global.level_score)
	Global.high_score = SaveLoad.get_current_level_high_score(level)
	#$Transition.fade_out()
	get_tree().change_scene_to_file("res://objects/victory_screen.tscn")

func _on_out_of_lives() -> void:
	
	get_tree().change_scene_to_file("res://objects/loss_screen.tscn")
