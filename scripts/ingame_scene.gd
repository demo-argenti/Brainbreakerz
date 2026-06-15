extends Node2D

@onready var Spykez = $Spykez
@onready var Crash = $Crash
@onready var Grem = $Grem

var ZombieDie = preload("res://objects/zombie_die.tscn")
var ZombieFall = preload("res://objects/zombie_fall.tscn")

# Feedback isnt working yet so func's that use it are commented out
var Feedback = preload("res://objects/Feedback.tscn")
var ZombieDeath = preload("res://objects/zombie_death.tscn")
# TODO remove ts, reference to current song/chart to be handled by global system
#@export_enum("tutorial", "level_1", "level_2", "level_3", "bonus_level") var level: int
#@export var chart_name: String # just for now!
#@export var song_def : SongDef
#@export var chart_idx : int

func _ready() -> void:
	#if song_def: Conductor.load_chartdef(song_def,chart_idx)
	#else: Global.current_level = level
	#else: assert(false, "no songdef!")
	Conductor.load_chartdef(Global.current_song,Global.current_chart_idx)
	
	Dialogic.timeline_ended.connect(_on_dialogic_tl_ended)
	
	# TODO replace this with code that handles events
	Conductor.finished.connect(_on_conductor_finished)
	
	if Calibration.has_instance:
		$PerfectSplat.volume_linear = 0
		$HitSplat.volume_linear = 0
		$MissScratch.volume_linear = 0
	else:
		Global.out_of_lives.connect(_on_out_of_lives)
	
	$KeyListener.connect("Hit", SpykezZombieDie)
	$KeyListener2.connect("Hit", CrashZombieDie)
	$KeyListener3.connect("Hit", GremZombieDie)
	#ZombieDeath.connect("Done", remove)
	#Global.is_high_score = false
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
	
	if !Calibration.has_instance:
		$KeyListener2.connect("PerfectHit", CrashPerfect)
		$KeyListener2.connect("GreatHit", CrashGreat)
		$KeyListener2.connect("GoodHit", CrashGood)
		$KeyListener2.connect("MissHit", CrashMiss)
	
	$KeyListener3.connect("PerfectHit", GremPerfect)
	$KeyListener3.connect("GreatHit", GremGreat)
	$KeyListener3.connect("GoodHit", GremGood)
	$KeyListener3.connect("MissHit", GremMiss)
	
	await(Transition.fade_in_finished)
	
	if Global.current_song.events.has("before"):
		# TODO briefly looking at this function in dialogic,
		# if we wanna allow custom scenes it's not gonna work as-is for stuff
		# outside res:// (the pck file) or user:// (i don't wanna make users stick stuff in there...)
		# we may ultimately have to modify the add-on
		current_event = SCN_PRESONG
		Dialogic.start_timeline(Global.current_song.events.before)
	else: Conductor.begin_playback()

enum { SCN_NONE, SCN_PRESONG, SCN_POSTSONG }
var current_event := SCN_NONE

func _on_dialogic_tl_ended() -> void:
	match current_event:
		SCN_PRESONG: Conductor.begin_playback()
		SCN_POSTSONG: get_tree().change_scene_to_file("res://objects/victory_screen.tscn"
									if !Calibration.has_instance
									else "res://objects/options_menu.tscn")
		_: assert(false,"Scripting error (Unanticipated Dialogic timeline end?)")



# TODO make generic playersprite object and move this kinda stuff there
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


func remove() -> void: ZombieDeath.queue_free()


func _on_conductor_finished() -> void:
	# HACK
	Dialogic.VAR.latency = "%.1fms" % [ Calibration.audio_latency * 1000.0 ]
	# TODO rework this??
	if Global.current_song.events.has("after"):
		current_event = SCN_POSTSONG
		Dialogic.start_timeline(Global.current_song.events.after)
	else: get_tree().change_scene_to_file("res://objects/victory_screen.tscn"
									if !Calibration.has_instance
									else "res://objects/options_menu.tscn")


func _on_out_of_lives() -> void:
	Conductor.stop()
	get_tree().change_scene_to_file("res://objects/loss_screen.tscn")
