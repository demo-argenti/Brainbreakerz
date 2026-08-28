extends CanvasLayer

signal fade_in_finished
var scene

# TODO temp patch! delete!
@export var level := "Empty"

func _ready() -> void:
	scene = null
	hide()
	pass

func transition(scene:String,fade_music:=false) -> void:
	self.scene = scene
	show()
	$AnimationPlayer.play("fade_out")
	
	if fade_music: Conductor.fade_and_stop(0.5) # slightly faster than the trans anim


func transition_to_chart(song:SongDef,chart_idx:int=0) -> void:
	assert(false,"don't use this")
	## hacky
	#self.scene = "res://Levels/calibration_scene.tscn" if song.song_title=="Calibration Track"\
			#else "res://Levels/ingame_scene.tscn" 
	#show()
	#$AnimationPlayer.play("fade_out")
	#ConductorNew.fade_and_stop(0.5)
	#print("a")
	#ConductorNew.load_chartdef(song,chart_idx)


func fade_out() -> void:
	visible = true
	$Transition.play()


func fade_in() -> void:
	#visible = true
	$Transition.play_backwards()
	visible = false


func _on_animation_player_animation_finished(anim_name) -> void:
	if (anim_name == "fade_out"):
		if Global.queued_song: Global._pop_queue()
		get_tree().change_scene_to_file(scene)
		$AnimationPlayer.play("fade_in")
	elif (anim_name == "fade_in"):
		fade_in_finished.emit()
		hide()
