extends CanvasLayer

signal on_fade_out_finished
var scene

func _ready():
	scene = null
	hide()
	pass

func transition(scene : String):
	self.scene = scene
	show()
	$AnimationPlayer.play("fade_out")


func fade_out():
	visible = true
	$Transition.play()
	
	
func fade_in():
	visible = true
	$Transition.play_backwards()
	visible = false


func _on_animation_player_animation_finished(anim_name):
	if(anim_name == "fade_out"):
		on_fade_out_finished.emit()
		get_tree().change_scene_to_file(scene)
		$AnimationPlayer.play("fade_in")
	elif(anim_name == "fade_in"):
		hide()
	pass # Replace with function body.
